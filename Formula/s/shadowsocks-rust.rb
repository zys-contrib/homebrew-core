class ShadowsocksRust < Formula
  desc "Rust port of Shadowsocks"
  homepage "https://github.com/shadowsocks/shadowsocks-rust"
  url "https://github.com/shadowsocks/shadowsocks-rust/archive/refs/tags/v1.19.1.tar.gz"
  sha256 "ac1d396fddec990477588b89dd27dc55cb9e10320ae7a2d8bae20fb3bfeed320"
  license "MIT"
  head "https://github.com/shadowsocks/shadowsocks-rust.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "81cfc3b0aebd8d22468e833bc07822e027b90038aa58ef33ea951e34a428f28f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2fe942f0abf777149dd75f2343a906f9f2a2e2139e6f5029aa1d7213a359b94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8be8cb2fb0b66c32dc5ca78ffc7df6fe903110bb140e1a0b3a7c4b1ec46d1f3"
    sha256 cellar: :any_skip_relocation, sonoma:         "d9a356ad5fc2e230caceb77b7b1abc438a8b42ef3b99508822ebd509d3dfe1dd"
    sha256 cellar: :any_skip_relocation, ventura:        "c82c8b9190cbfe5df794b930f1b2ed14500f2637538b06036f861a04d325ded0"
    sha256 cellar: :any_skip_relocation, monterey:       "ad7d1da0b778d6dab59b2a0f6330b28806b60fa97bacfff34f3020ad6391bde6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c20dce95419785c442234740fe52b8bd9729ee48fafbdc1cd9742d428c8ca408"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    server_port = free_port
    local_port = free_port

    (testpath/"server.json").write <<~EOS
      {
          "server":"127.0.0.1",
          "server_port":#{server_port},
          "password":"mypassword",
          "method":"aes-256-gcm"
      }
    EOS
    (testpath/"local.json").write <<~EOS
      {
          "server":"127.0.0.1",
          "server_port":#{server_port},
          "password":"mypassword",
          "method":"aes-256-gcm",
          "local_address":"127.0.0.1",
          "local_port":#{local_port}
      }
    EOS
    fork { exec bin/"ssserver", "-c", testpath/"server.json" }
    fork { exec bin/"sslocal", "-c", testpath/"local.json" }
    sleep 3

    output = shell_output "curl --socks5 127.0.0.1:#{local_port} https://example.com"
    assert_match "Example Domain", output
  end
end
