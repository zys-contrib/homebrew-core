class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.11.13.tar.gz"
  sha256 "903d61cb1ae3b4782f294e2429ede8c6929d764e61c04331fcc448c28e9adbba"
  license "GPL-3.0-or-later"
  head "https://github.com/SagerNet/sing-box.git", branch: "dev-next"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1227b748b70d882fa87d7fe34090fc51a7d724f105736831aa910e566406ab72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ea24bba8a284b70e4a20d1a03badbd9b5bae05ba598e4e8bb9d744faf98c8a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "02111c8645f8eb43a58e7186de7abd75ef3a9dd8ad6909eb2ada1da45f3fd867"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e80af6c7fba224dfac60957b7d4d52d61618a710257be28d722dc4aee57af10"
    sha256 cellar: :any_skip_relocation, ventura:       "80c206dbb14413b872bdab5d4ee60b81b968e54f88f41c0ac7a17ee2e608b33c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3020f190e0d157b4d56bcad3fd5ffe4f1c790ff9071155f890523b7122d8b2e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sagernet/sing-box/constant.Version=#{version} -buildid="
    tags = "with_gvisor,with_quic,with_wireguard,with_utls,with_reality_server,with_clash_api"
    system "go", "build", *std_go_args(ldflags:, tags:), "./cmd/sing-box"
    generate_completions_from_executable(bin/"sing-box", "completion")
  end

  service do
    run [opt_bin/"sing-box", "run", "--config", etc/"sing-box/config.json", "--directory", var/"lib/sing-box"]
    run_type :immediate
    keep_alive true
  end

  test do
    ss_port = free_port
    (testpath/"shadowsocks.json").write <<~JSON
      {
        "inbounds": [
          {
            "type": "shadowsocks",
            "listen": "::",
            "listen_port": #{ss_port},
            "method": "2022-blake3-aes-128-gcm",
            "password": "8JCsPssfgS8tiRwiMlhARg=="
          }
        ]
      }
    JSON
    server = fork { exec bin/"sing-box", "run", "-D", testpath, "-c", testpath/"shadowsocks.json" }

    sing_box_port = free_port
    (testpath/"config.json").write <<~JSON
      {
        "inbounds": [
          {
            "type": "mixed",
            "listen": "::",
            "listen_port": #{sing_box_port}
          }
        ],
        "outbounds": [
          {
            "type": "shadowsocks",
            "server": "127.0.0.1",
            "server_port": #{ss_port},
            "method": "2022-blake3-aes-128-gcm",
            "password": "8JCsPssfgS8tiRwiMlhARg=="
          }
        ]
      }
    JSON
    system bin/"sing-box", "check", "-D", testpath, "-c", "config.json"
    client = fork { exec bin/"sing-box", "run", "-D", testpath, "-c", "config.json" }

    sleep 3
    begin
      system "curl", "--socks5", "127.0.0.1:#{sing_box_port}", "github.com"
    ensure
      Process.kill 9, server
      Process.wait server
      Process.kill 9, client
      Process.wait client
    end
  end
end
