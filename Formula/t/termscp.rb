class Termscp < Formula
  desc "Feature rich terminal file transfer and explorer"
  homepage "https://termscp.veeso.dev/"
  url "https://github.com/veeso/termscp/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "58f3b4770c5d1c5d7998af88b6df8c6a53dee4409f2cf6ea676caccec79cdb7f"
  license "MIT"
  head "https://github.com/veeso/termscp.git", branch: "main"

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "dbus"
    depends_on "samba"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"
    PTY.spawn(bin/"termscp", "config") do |_r, _w, pid|
      sleep 10
      Process.kill 9, pid
    end
  end
end
