class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.16.0",
      revision: "dd6212261c57e41e1bf42532809a14a00c9072a9"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f7b7fdd134fd91e15b7bd28ef68999e0fa5840fe390d0e317d31a6546a70bf7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cddafa5c4f32dcf46bdcd2e4677696c56f99e604e43e0defcb6bb459e9b9e941"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0f006be8307cd9f81206fb16d1e83144b88555f096839e0e5775cae3be385dc3"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d0f528ec78546ea0c6427655102e3b80a97980f14cb876e71f5c3b70c1880ec"
    sha256 cellar: :any_skip_relocation, ventura:       "ae7a0b601fe278720c8fed7eef64e6f7d20d8e1da36ad96f91302f2204242ea6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7580b862510f322f13723d10a92a3570174c964fc992e34e2a6899888f899f50"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.12" => :build

  uses_from_macos "libpcap"

  def install
    # remove non open source files
    rm_r("x-pack")

    cd "packetbeat" do
      # prevent downloading binary wheels during python setup
      system "make", "PIP_INSTALL_PARAMS=--no-binary :all", "python-env"
      system "mage", "-v", "build"
      ENV.deparallelize
      system "mage", "-v", "update"

      inreplace "packetbeat.yml", "packetbeat.interfaces.device: any", "packetbeat.interfaces.device: en0"

      (etc/"packetbeat").install Dir["packetbeat.*", "fields.yml"]
      (libexec/"bin").install "packetbeat"
      prefix.install "_meta/kibana"
    end

    (bin/"packetbeat").write <<~EOS
      #!/bin/sh
      exec #{libexec}/bin/packetbeat \
        --path.config #{etc}/packetbeat \
        --path.data #{var}/lib/packetbeat \
        --path.home #{prefix} \
        --path.logs #{var}/log/packetbeat \
        "$@"
    EOS

    chmod 0555, bin/"packetbeat" # generate_completions_from_executable fails otherwise
    generate_completions_from_executable(bin/"packetbeat", "completion", shells: [:bash, :zsh])
  end

  service do
    run opt_bin/"packetbeat"
  end

  test do
    eth = if OS.mac?
      "en"
    else
      "eth"
    end
    assert_match "0: #{eth}0", shell_output("#{bin}/packetbeat devices")
    assert_match version.to_s, shell_output("#{bin}/packetbeat version")
  end
end
