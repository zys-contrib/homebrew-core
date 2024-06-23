class Pc6001vx < Formula
  desc "PC-6001 emulator"
  # http://eighttails.seesaa.net/ gives 405 error
  homepage "https://github.com/eighttails/PC6001VX"
  url "https://eighttails.up.seesaa.net/bin/PC6001VX_4.2.8_src.tar.gz"
  sha256 "18d33c364f8d28c06de9df67c5fa46fe4c14dacbe5f56d2c64af8403e64d64c0"
  license "LGPL-2.1-or-later"
  head "https://github.com/eighttails/PC6001VX.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "eb94c7d377ecec997c0dc16f75fdbebe1e5c6f95c66ef4eab47b5be4af3ad86b"
    sha256 cellar: :any, arm64_ventura:  "d1d69d055e56c8d7f71d4309ac2bb07ec8dc363f18398abe33735c6c978491b5"
    sha256 cellar: :any, arm64_monterey: "b0f1ebbdeadccd8a14942f83a8f0d8facfb8f22669e09ea2e8ec02c474197680"
    sha256 cellar: :any, sonoma:         "5bec39dccbf04f4d4a6437d720b5debff48c550e8690a5803c00b52cd52305ec"
    sha256 cellar: :any, ventura:        "d1084cb81da89c09bb51b15ca1af56676481b67469010d7760919bc9e8870cb9"
    sha256 cellar: :any, monterey:       "9e74efd930f82983c2198e47d5e92ab6a667fe58c23180dcf63ce59ca31727b8"
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg@6"
  depends_on "qt"
  depends_on "sdl2"

  on_macos do
    depends_on "gettext"
  end

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    mkdir "build" do
      system "qmake", "PREFIX=#{prefix}",
                                 "QMAKE_CXXFLAGS=#{ENV.cxxflags}",
                                 "CONFIG+=no_include_pwd",
                                 ".."
      system "make"

      prefix.install "PC6001VX.app"
      bin.write_exec_script "#{prefix}/PC6001VX.app/Contents/MacOS/PC6001VX"
    end
  end

  test do
    # locales aren't set correctly within the testing environment
    ENV["LC_ALL"] = "en_US.UTF-8"
    user_config_dir = testpath/".pc6001vx4"
    user_config_dir.mkpath
    pid = fork do
      exec bin/"PC6001VX"
    end
    sleep 30
    assert_predicate user_config_dir/"rom",
                     :exist?, "User config directory should exist"
  ensure
    # the first SIGTERM signal closes a window which spawns another immediately
    # after 5 seconds, send a second SIGTERM signal to ensure the process is fully stopped
    Process.kill("TERM", pid)
    sleep 5
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
