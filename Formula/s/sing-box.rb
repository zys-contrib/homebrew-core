class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.11.2.tar.gz"
  sha256 "4b47ebc0d7d1cd6c79c71773b65cbb9c083e9e555021bad530f88590b5621c4e"
  license "GPL-3.0-or-later"
  head "https://github.com/SagerNet/sing-box.git", branch: "dev-next"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4eb8bdbfbffe5889471cd3b9319f3fb918c1dd2fe44171aad8c3b53502814d06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a36a39ebe72661407ec9ad8ed89985d6d4b542f6cddf6fb25909b94522c62c99"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8679348b9b7b688f1add504fb313cdf328ec937ba939c325b6e4236e3b1d2dc7"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad9c3dc19f7db2af1d6eec964a561e78712e6d0f5077a4554999060fcf119ffd"
    sha256 cellar: :any_skip_relocation, ventura:       "aa1ae6671d0a11599b8fce8c4498ac514fd69db5c4b6f35c28efe6c74fb1e801"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee225a2382a76c5fbcc8db31db6afb0b7b318e080bdb3f05c0ab0aa1d7ceff90"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sagernet/sing-box/constant.Version=#{version} -buildid="
    tags = "with_gvisor,with_quic,with_wireguard,with_utls,with_reality_server,with_clash_api"
    system "go", "build", "-tags", tags, *std_go_args(ldflags:), "./cmd/sing-box"
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
