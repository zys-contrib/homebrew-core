class Mbpoll < Formula
  desc "Command-line utility to communicate with ModBus slave (RTU or TCP)"
  homepage "https://epsilonrt.fr"
  url "https://github.com/epsilonrt/mbpoll/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "7d960cd4459b5f7c2412abc51aba93a20b6114fd75d1de412b1e540cfb63bfec"
  license "GPL-3.0-only"
  head "https://github.com/epsilonrt/mbpoll.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libmodbus"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # NOTE: using "1.0-0" and not "1.5.2"
    # upstream fix pr: https://github.com/epsilonrt/mbpoll/pull/58
    assert_match "1.0-0", shell_output("#{bin}/mbpoll -V")

    assert_match "Connection failed", shell_output("#{bin}/mbpoll -1 -o 0.01 -q -m tcp invalid.host 2>&1", 1)
  end
end
