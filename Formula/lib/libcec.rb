class Libcec < Formula
  desc "Control devices with TV remote control and HDMI cabling"
  homepage "https://libcec.pulse-eight.com/"
  url "https://github.com/Pulse-Eight/libcec/archive/refs/tags/libcec-7.1.0.tar.gz"
  sha256 "7fd60dfd25b0b116c58439bb70158c1d5fd8fd492ad2a1a3b39b826bb50b54f6"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6c3e6496b7aa4fc0b2ccb840c23b2881ce4f0d1a4419854c1e21e6e316a98b7f"
    sha256 cellar: :any,                 arm64_sonoma:  "de4f26ed875eb592e3fc420963d62ffe939f38745951eacdb431517d3c297eed"
    sha256 cellar: :any,                 arm64_ventura: "a3f634f61d5a27f31057a3e5deec39973d7bbdda09a8cefeeb903bf155411587"
    sha256 cellar: :any,                 sonoma:        "559cbd188d933dad82b923434da5cbdcbc8f59972f157d04b518e968a05a62dc"
    sha256 cellar: :any,                 ventura:       "a942eaf1c28a2ac335203421541da6347dc4f5bd5da1ce5015241d79dc845d73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8dc79b71ae7d6917a919038ee0aa6a75adf4f97a6ea49dd389ee54efc53d5e9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "916e33306e1006b5a8c5337c8ed5341c445598bb5eb90de65137ff1bbc0a1225"
  end

  depends_on "cmake" => :build

  uses_from_macos "ncurses"

  resource "p8-platform" do
    url "https://github.com/Pulse-Eight/platform/archive/refs/tags/p8-platform-2.1.0.1.tar.gz"
    sha256 "064f8d2c358895c7e0bea9ae956f8d46f3f057772cb97f2743a11d478a0f68a0"

    livecheck do
      url "https://github.com/Pulse-Eight/platform.git"
      regex(/^p8-platform[._-]v?(\d+(?:\.\d+)+)$/i)
    end
  end

  def install
    ENV.cxx11

    # The CMake scripts don't work well with some common LIBDIR values:
    # - `CMAKE_INSTALL_LIBDIR=lib` is interpreted as path relative to build dir
    # - `CMAKE_INSTALL_LIBDIR=#{lib}` breaks pkg-config and cmake config files
    # - Setting no value uses UseMultiArch.cmake to set platform-specific paths
    # To avoid these issues, we can specify the type of input as STRING
    cmake_args = std_cmake_args.map do |s|
      s.gsub "-DCMAKE_INSTALL_LIBDIR=", "-DCMAKE_INSTALL_LIBDIR:STRING="
    end

    resource("p8-platform").stage do
      # upstream commit, https://github.com/Pulse-Eight/platform/commit/d7faed1c696b1a6a67f114a63a0f4c085f0f9195
      ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"
      odie "remove CMAKE_POLICY_VERSION_MINIMUM env" if resource("p8-platform").version > "2.1.0.1"

      system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *cmake_args
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "libCEC version: #{version}", shell_output("#{bin}/cec-client --info")
  end
end
