class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "022c9b3db7afb0d0dec6f13ddeb44ebccf84c4697c184a4fc36991e995d3a14f"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3f3061d8355561e68c46b68fdbbf66480100d9fc7d9c64d0c2619d71b2303f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7c36b1c4f110f00c692b2cbcac1fe46f76aeb009b75ee508cc4f45b9958a3fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0c5a7dacb70b8c0c9dd549839d9da7580d81bb1a7e34d1c073a3621e0be100ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "001c39a2928d736ca66acedcfb50e735de1374d2aba6ff97d117a7d9abc83b5e"
    sha256 cellar: :any_skip_relocation, ventura:       "eef670ba891f920be08beddbbd33e8a3c0dbaf7971d521a3a16c4af2d9afddc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50ecc922c8f4bf9924c4e8e001b4a48b63be9c345a1be16336658ff4e41fbf94"
  end

  depends_on "go" => :build

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
