class Pybind11 < Formula
  desc "Seamless operability between C++11 and Python"
  homepage "https://github.com/pybind/pybind11"
  url "https://github.com/pybind/pybind11/archive/refs/tags/v2.13.3.tar.gz"
  sha256 "6e7a84ec241544f2f5e30c7a82c09c81f0541dd14e9d9ef61051e07105f9c445"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6eea0972b2ca3d06ccf9fe4dffe96ec15a6a38f9c6b5ba2494c4e76622371abb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6eea0972b2ca3d06ccf9fe4dffe96ec15a6a38f9c6b5ba2494c4e76622371abb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6eea0972b2ca3d06ccf9fe4dffe96ec15a6a38f9c6b5ba2494c4e76622371abb"
    sha256 cellar: :any_skip_relocation, sonoma:         "28cf03781b5db4edb3b9947bd2ba062aed4610f55ac867729e1c8542d06bcfa3"
    sha256 cellar: :any_skip_relocation, ventura:        "28cf03781b5db4edb3b9947bd2ba062aed4610f55ac867729e1c8542d06bcfa3"
    sha256 cellar: :any_skip_relocation, monterey:       "28cf03781b5db4edb3b9947bd2ba062aed4610f55ac867729e1c8542d06bcfa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6eea0972b2ca3d06ccf9fe4dffe96ec15a6a38f9c6b5ba2494c4e76622371abb"
  end

  depends_on "cmake" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@3\.\d+$/) }
  end

  def install
    # Install /include and /share/cmake to the global location
    system "cmake", "-S", ".", "-B", "build", "-DPYBIND11_TEST=OFF", "-DPYBIND11_NOPYTHON=ON", *std_cmake_args
    system "cmake", "--install", "build"

    pythons.each do |python|
      # Install Python package too
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args(prefix: libexec), "."

      site_packages = Language::Python.site_packages(python_exe)
      pth_contents = "import site; site.addsitedir('#{libexec/site_packages}')\n"
      (prefix/site_packages/"homebrew-pybind11.pth").write pth_contents

      pyversion = Language::Python.major_minor_version(python_exe)
      bin.install libexec/"bin/pybind11-config" => "pybind11-config-#{pyversion}"

      next if python != pythons.max_by(&:version)

      # The newest one is used as the default
      bin.install_symlink "pybind11-config-#{pyversion}" => "pybind11-config"
    end
  end

  test do
    (testpath/"example.cpp").write <<~EOS
      #include <pybind11/pybind11.h>

      int add(int i, int j) {
          return i + j;
      }
      namespace py = pybind11;
      PYBIND11_MODULE(example, m) {
          m.doc() = "pybind11 example plugin";
          m.def("add", &add, "A function which adds two numbers");
      }
    EOS

    (testpath/"example.py").write <<~EOS
      import example
      example.add(1,2)
    EOS

    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      pyversion = Language::Python.major_minor_version(python_exe)
      site_packages = Language::Python.site_packages(python_exe)

      python_flags = Utils.safe_popen_read(
        python.opt_libexec/"bin/python-config",
        "--cflags",
        "--ldflags",
        "--embed",
      ).split
      system ENV.cxx, "-shared", "-fPIC", "-O3", "-std=c++11", "example.cpp", "-o", "example.so", *python_flags
      system python_exe, "example.py"

      test_module = shell_output("#{python_exe} -m pybind11 --includes")
      assert_match (libexec/site_packages).to_s, test_module

      test_script = shell_output("#{bin}/pybind11-config-#{pyversion} --includes")
      assert_match test_module, test_script

      next if python != pythons.max_by(&:version)

      test_module = shell_output("#{python_exe} -m pybind11 --includes")
      test_script = shell_output("#{bin}/pybind11-config --includes")
      assert_match test_module, test_script
    end
  end
end
