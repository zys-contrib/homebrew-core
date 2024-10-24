class ShadowsocksRust < Formula
  desc "Rust port of Shadowsocks"
  homepage "https://github.com/shadowsocks/shadowsocks-rust"
  url "https://github.com/shadowsocks/shadowsocks-rust/archive/refs/tags/v1.21.1.tar.gz"
  sha256 "bdb55a2bbfd809de1853abb3b92bec9c713b98d87a188b71768906eae38fbc1e"
  license "MIT"
  head "https://github.com/shadowsocks/shadowsocks-rust.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9b1f8ddec393d4b7818737c7857e05a8600212ea8be07ecaee4317c4d0acf22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96cdead9922bca2519a0d6b960824352c0988f450772ccc9805bbd19d6558b8b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b5f4bed2275bec106ab4c1435d6583aa12bde3fd994b30a23a3c859355e280af"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6b51d2ca14e1139139504eb4d5930dbe1e831cc54567785d0803283c06bc94b"
    sha256 cellar: :any_skip_relocation, ventura:       "d8c115df1b3d8b163e9775fe6cb43d010fdfd689a9d9bd6d8154770ca8f9b30c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9738e38850b9ce05919b9b0fabfadb376aacd5ff3b7b2851406199d1fb5b1cfe"
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
