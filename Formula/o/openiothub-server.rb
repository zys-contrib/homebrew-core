class OpeniothubServer < Formula
  desc "Server for OpenIoTHub"
  homepage "https://github.com/OpenIoTHub/server-go"
  url "https://github.com/OpenIoTHub/server-go.git",
      tag:      "v1.2.3",
      revision: "1edf654c92fc0e7fb27be34b5ec1c8ef8f99e7b9"
  license "MIT"
  head "https://github.com/OpenIoTHub/server-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "57ad4e7d2fd1a690fa83f2b3db0bf18463042dcd2a1061f76d2f4d28ad605098"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57ad4e7d2fd1a690fa83f2b3db0bf18463042dcd2a1061f76d2f4d28ad605098"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57ad4e7d2fd1a690fa83f2b3db0bf18463042dcd2a1061f76d2f4d28ad605098"
    sha256 cellar: :any_skip_relocation, sonoma:         "c1518b3e90d5a888d76c2c0c874c678b11017745dbbffe8739ac9c98792703e3"
    sha256 cellar: :any_skip_relocation, ventura:        "c1518b3e90d5a888d76c2c0c874c678b11017745dbbffe8739ac9c98792703e3"
    sha256 cellar: :any_skip_relocation, monterey:       "c1518b3e90d5a888d76c2c0c874c678b11017745dbbffe8739ac9c98792703e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26450c3d9085eb3ea1033db7a8eb68eec7b1183193ed75731a3ff187808c8f33"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
      -X main.builtBy=#{tap.user}
    ]

    (etc/"server-go").mkpath
    system "go", "build", "-mod=vendor", *std_go_args(ldflags:)
    bin.install_symlink bin/"openiothub-server" => "server-go"
    etc.install "server-go.yaml" => "server-go/server-go.yaml"
  end

  service do
    run [opt_bin/"openiothub-server", "-c", etc/"server-go.yaml"]
    keep_alive true
    log_path var/"log/openiothub-server.log"
    error_log_path var/"log/openiothub-server.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openiothub-server -v 2>&1")
    assert_match "config created", shell_output("#{bin}/openiothub-server init --config=server.yml 2>&1")
    assert_predicate testpath/"server.yml", :exist?
  end
end
