class Identme < Formula
  desc "Public IP address lookup"
  homepage "https://www.ident.me"
  url "https://github.com/pcarrier/ident.me/archive/refs/tags/v0.5.tar.gz"
  sha256 "5d33131694f62d1560fe85f4fc8546109d8cfb704ca8100b71047fe76a7aa71a"
  license "0BSD"

  depends_on "cmake" => :build
  uses_from_macos "curl"

  def install
    system "cmake", "-S", "cli", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "ipv4", shell_output("#{bin}/identme --json -4")
  end
end
