class Rshijack < Formula
  desc "TCP connection hijacker"
  homepage "https://github.com/kpcyrd/rshijack"
  url "https://github.com/kpcyrd/rshijack/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "c13cc07825d72f09887ec0f098aa40d335f73a0bc0b31c4d1e7431271e1cb53e"
  license "GPL-3.0-or-later"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    interface = OS.mac? ? "lo0" : "lo"
    src = "192.0.2.1:12345"
    dst = "192.0.2.2:54321"

    output = shell_output("#{bin}/rshijack #{interface} #{src} #{dst} 2>&1", 1)
    assert_match "Waiting for SEQ/ACK to arrive", output

    assert_match version.to_s, shell_output("#{bin}/rshijack --version")
  end
end
