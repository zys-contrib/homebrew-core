class Pivy < Formula
  desc "Python bindings to coin3d"
  homepage "https://github.com/coin3d/pivy"
  url "https://github.com/coin3d/pivy/archive/refs/tags/0.6.10.tar.gz"
  sha256 "7b409816c9fad84cf94f93659281f9dd2501d285eb2fc609e9401a3d004ce723"
  license "ISC"
  head "https://github.com/coin3d/pivy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "49312c6ceb49fc4e4141430afe844ed52fb2f828445497fb74a695dd1c7c23dc"
    sha256 cellar: :any,                 arm64_ventura: "37951e1aeb75c56bcb13e495dc15a70b7658c75bdc2ae782cdec2adf5b4180e4"
    sha256 cellar: :any,                 sonoma:        "4aef1788e33fd3bed8094c79592e374525d579068517e7e4a6c66f4f36669343"
    sha256 cellar: :any,                 ventura:       "73554f28642f20a5c770d7dd948f6cc44c140f0a0ce142f4754de42621d02f5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "773ce675502fc88dd841d625e99b748d03b7519a962a3deb7239d456810491cf"
  end

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "coin3d"
  depends_on "pyside"
  depends_on "python@3.13"
  depends_on "qt"

  def python3
    "python3.13"
  end

  def install
    site_packages = prefix/Language::Python.site_packages(python3)
    rpaths = [rpath(source: site_packages/"pivy"), rpath(source: site_packages/"pivy/gui")]

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}",
                    "-DPython_EXECUTABLE=#{which(python3)}",
                    "-DPIVY_Python_SITEARCH=#{site_packages}",
                    "-DPIVY_USE_QT6=ON",
                    *std_cmake_args(find_framework: "FIRST")
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Set QT_QPA_PLATFORM to minimal to avoid error:
    # "This application failed to start because no Qt platform plugin could be initialized."
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system python3, "-c", <<~PYTHON
      import shiboken6
      from pivy.quarter import QuarterWidget
      from pivy.sogui import SoGui
      assert SoGui.init("test") is not None
    PYTHON
  end
end
