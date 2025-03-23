class Cryptominisat < Formula
  desc "Advanced SAT solver"
  homepage "https://www.msoos.org/cryptominisat5/"
  url "https://github.com/msoos/cryptominisat/archive/refs/tags/5.12.1.tar.gz"
  sha256 "fa504ae5846c80a3650fda620383def7f3d1d9d5d08824b57e13c4d41e881d89"
  # Everything that's needed to run/build/install/link the system is MIT licensed. This allows
  # easy distribution and running of the system everywhere.
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia: "48e71ad8b236eb736317e8b39f1a1fac2334e345b315aa9cd04bc843fe706580"
    sha256 cellar: :any,                 arm64_sonoma:  "bbeb9f9fe45dd2c144870ffa0a77c3b332c694cc7fa4e4c17cf219f4f3ab16c2"
    sha256 cellar: :any,                 arm64_ventura: "5ffbbf9b609d5a8e0e5dc2bce7237b0a6a7ed184bae66fa4a3a68c9f650b80c2"
    sha256 cellar: :any,                 sonoma:        "15d86b66627d95536445093c9702b5fcf439e6a6ad67037cc192b5bdec5f5e8b"
    sha256 cellar: :any,                 ventura:       "ed2723cfbf766a67cfea9a20aba7be51b4b05e0a6f723da3b1133e4260561828"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "032b8da9b23bdd1c81b7c62fd88126c4400ab74804c6e2b38f6a03e60d728d41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4291fd6c5691c5de3eeaadb1f6bee8dd83ec80e3ae9dd23baf2a48069b741ef8"
  end

  depends_on "cmake" => :build
  depends_on "python@3.13" => [:build, :test]
  depends_on "gmp"

  uses_from_macos "zlib"

  # Currently using latest commit from `mate-only-libraries-1.8.0` branch.
  # Check cryptominisat README.markdown and/or CI workflow to see if branch has changed.
  resource "cadical" do
    url "https://github.com/meelgroup/cadical/archive/c90592eab35a4a26ad901367db3cd727c5ab79c5.tar.gz"
    sha256 "ac54f000b26083c44873e0ce581dac1cb56f91a8835082287b391af089547c3d"
  end

  # Currently using a git checkout of `mate` branch as the generate script runs `git show`.
  # Check cryptominisat README.markdown and/or CI workflow to see if branch has changed.
  resource "cadiback" do
    url "https://github.com/meelgroup/cadiback.git",
        revision: "ea65a9442fc2604ee5f4ffd0f0fdd0bf481d5b42"
  end

  # Apply Arch Linux patch to avoid rebuilding C++ library for Python bindings
  patch do
    url "https://gitlab.archlinux.org/archlinux/packaging/packages/cryptominisat/-/raw/20200db986b018b724363352954cfef8006da079/python-system-libs.patch"
    sha256 "0fb932fbf83c351568f54fc238827709e6cc2646d124af751050cfde0c255254"
  end

  # Apply Arch Linux patch to avoid paths to non-installed static libraries in CMake config file
  patch do
    url "https://gitlab.archlinux.org/archlinux/packaging/packages/cryptominisat/-/raw/f8e0e60b7d4fd9aa185a1a1a55dcd2b7ea123d58/link-private.patch"
    sha256 "a5006f49e8adf1474725d2a3e4205cdd65beb2f100f5538b2f89e14de0613e0f"
  end

  def python3
    "python3.13"
  end

  def install
    # fix audit failure with `lib/libcryptominisat5.5.7.dylib`
    inreplace "src/GitSHA1.cpp.in", "@CMAKE_CXX_COMPILER@", ENV.cxx

    (buildpath/name).install buildpath.children
    (buildpath/"cadical").install resource("cadical")
    (buildpath/"cadiback").install resource("cadiback")

    cd "cadical" do
      system "./configure"
      system "make", "-C", "build", "libcadical.a"
    end

    cd "cadiback" do
      system "./configure"
      system "make", "libcadiback.a"
    end

    system "cmake", "-S", name, "-B", "build", "-DMIT=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath(source: prefix/Language::Python.site_packages(python3))}"
    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "./#{name}"
  end

  test do
    (testpath/"simple.cnf").write <<~EOS
      p cnf 3 4
      1 0
      -2 0
      -3 0
      -1 2 3 0
    EOS
    result = shell_output("#{bin}/cryptominisat5 simple.cnf", 20)
    assert_match "s UNSATISFIABLE", result

    (testpath/"test.py").write <<~PYTHON
      import pycryptosat
      solver = pycryptosat.Solver()
      solver.add_clause([1])
      solver.add_clause([-2])
      solver.add_clause([-1, 2, 3])
      print(solver.solve()[1])
    PYTHON
    assert_equal "(None, True, False, True)\n", shell_output("#{python3} test.py")
  end
end
