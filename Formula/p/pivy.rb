class Pivy < Formula
  desc "Python bindings to coin3d"
  homepage "https://github.com/coin3d/pivy"
  license "ISC"
  head "https://github.com/coin3d/pivy.git", branch: "master"

  stable do
    url "https://github.com/coin3d/pivy/archive/refs/tags/0.6.9.tar.gz"
    sha256 "c207f5ed73089b2281356da4a504c38faaab90900b95639c80772d9d25ba0bbc"

    # Backport fix for Qt6 QtOpenGLWidgets
    patch do
      url "https://github.com/coin3d/pivy/commit/e81c5f32538891c740b90b5d2eb77fa6a9e1cb43.patch?full_index=1"
      sha256 "c54b660f09957ad7673d29328fb1cbe77b9eb4b090f2371b6e16b4c333e679c4"
    end
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
