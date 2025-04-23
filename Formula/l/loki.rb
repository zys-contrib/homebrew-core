class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "584d7f45cc85f884e8eb7e8ed8c35eacd2157c6edd0f2a2d0161ba39d22b86ae"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92503584e00da8c2b8f1bf5b5c9e8f031c0177070a112ed2d3f09f2c7dbd8d56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "545bb0f7881634f82e62456d35748a47dbe11096d9353de87ed3dcbb210c68a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2197674c9eb4e925cea20cb74f92a1c70503b4c291034d6b941584cc5cf77104"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6c2d989284d7746703c015f40c40191bca554d9d8805ae238c34ed1387d77c0"
    sha256 cellar: :any_skip_relocation, ventura:       "84e303f766d7a18ea9ea7a17c29c4d202c3764f22f0b7512f86cebddd3ce5599"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4669c32f34a014871f4b005be1f4008b1b9dc12095623ee3ae714438c2d8c90"
  end

  depends_on "go" => :build

  # Fix to failed parsing config: loki-local-config.yaml: yaml: unmarshal errors:
  # PR ref: https://github.com/grafana/loki/pull/16991
  patch do
    url "https://github.com/grafana/loki/commit/974d8cf5b04c0043ded02cfc3ee360cdff219674.patch?full_index=1"
    sha256 "56a06b0cae70464d738f7aa7c306446f73ceea4badef0502826de9fd1d0c3475"
  end
  patch do
    url "https://github.com/grafana/loki/commit/cc34c48732229f2edf742b5f69536aaa607edc56.patch?full_index=1"
    sha256 "d8f35a91af95d5fe2c1a3c77fa4f2394cb279b88a6c4f8cf22fd2b9d8376dca8"
  end
  patch do
    url "https://github.com/grafana/loki/commit/8ca1db1d24799468c0c6d0cd6b640a60eb246646.patch?full_index=1"
    sha256 "4e2925424bcd7a093f4986d3005c888b98edcdae82b71ec4d71b957f4a9cbcfb"
  end

  def install
    cd "cmd/loki" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
      inreplace "loki-local-config.yaml", "/tmp", var
      etc.install "loki-local-config.yaml"
    end
  end

  service do
    run [opt_bin/"loki", "-config.file=#{etc}/loki-local-config.yaml"]
    keep_alive true
    working_dir var
    log_path var/"log/loki.log"
    error_log_path var/"log/loki.log"
  end

  test do
    port = free_port

    cp etc/"loki-local-config.yaml", testpath
    inreplace "loki-local-config.yaml" do |s|
      s.gsub! "3100", port.to_s
      s.gsub! var, testpath
    end

    fork { exec bin/"loki", "-config.file=loki-local-config.yaml" }
    sleep 8

    output = shell_output("curl -s localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end
