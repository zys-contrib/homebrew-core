class Ola < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Open Lighting Architecture for lighting control information"
  homepage "https://www.openlighting.org/ola/"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 1

  stable do
    # TODO: Check if we can use unversioned `protobuf` at version bump
    url "https://github.com/OpenLightingProject/ola/releases/download/0.10.9/ola-0.10.9.tar.gz"
    sha256 "44073698c147fe641507398253c2e52ff8dc7eac8606cbf286c29f37939a4ebf"

    # fix liblo 0.32 header compatibility
    # upstream pr ref, https://github.com/OpenLightingProject/ola/pull/1954
    patch do
      url "https://github.com/OpenLightingProject/ola/commit/e083653d2d18018fe6ef42f757bc06462de87f28.patch?full_index=1"
      sha256 "1276aded269497fab2e3fc95653b5b8203308a54c40fe2dcd2215a7f0d0369de"
    end

    # Backport fix for protoc version detection
    patch do
      url "https://github.com/OpenLightingProject/ola/commit/aed518a81340a80765e258d1523b75c22a780052.patch?full_index=1"
      sha256 "7e48c0027b79e129c1f25f29fae75568a418b99c5b789ba066a4253b7176b00a"
    end
  end

  bottle do
    rebuild 2
    sha256 arm64_sequoia: "6756f75f71aeb38c7756dff6e090cfee952ca87692ca890a727d1b8dca4fdd30"
    sha256 arm64_sonoma:  "c6fe0ecacc9a978798587d54d22eea826132e4400a4f9e76fc533591a526460c"
    sha256 arm64_ventura: "344967cebfddd0b82cd24c29a65b7303798b65b9d93fd6977a1e62605b200ca9"
    sha256 sonoma:        "ffdb1bc51a8dfdae5135c5c701932c600ee0b0c91424db61e6e4d713f553edfe"
    sha256 ventura:       "ed977705d46715e70a8f882f979678e774ccdb8c083b0a85988c25d41c89032f"
    sha256 x86_64_linux:  "7db8dc0961d2189f7a6ca03d96b028a1555ebda7fc69395addb98c11698d2cee"
  end

  head do
    url "https://github.com/OpenLightingProject/ola.git", branch: "master"

    # Apply open PR to fix macOS HEAD build
    # PR ref: https://github.com/OpenLightingProject/ola/pull/1983
    patch do
      url "https://github.com/OpenLightingProject/ola/commit/b8134b82e15f19266c79620b9c3c012bc515357d.patch?full_index=1"
      sha256 "d168118436186f0a30f4f7f2fdfcde69a5d20a8dcbef61c586d89cfd8f513e33"
    end
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cppunit" => :build # TODO: remove once we no longer need to run tests
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "abseil"
  depends_on "liblo"
  depends_on "libmicrohttpd"
  depends_on "libusb"
  depends_on "numpy"
  depends_on "protobuf"
  depends_on "python@3.13"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "ncurses"

  on_linux do
    depends_on "util-linux"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/74/6e/e69eb906fddcb38f8530a12f4b410699972ab7ced4e21524ece9d546ac27/protobuf-5.28.3.tar.gz"
    sha256 "64badbc49180a5e401f373f9ce7ab1d18b63f7dd4a9cdc43c92b9f0b481cef7b"
  end

  # Apply open PR to support Protobuf 22+ API
  # PR ref: https://github.com/OpenLightingProject/ola/pull/1984
  patch do
    url "https://github.com/OpenLightingProject/ola/commit/4924c9908ea879b36dc9132768fca25f6f21a677.patch?full_index=1"
    sha256 "4d3ed12a41d4c2717cfbb3fa790ddf115b084c1d3566a4d2f0e52a8ab25053ef"
  end

  def python3
    "python3.13"
  end

  def extra_python_path
    opt_libexec/Language::Python.site_packages(python3)
  end

  def install
    # Workaround to build with newer Protobuf due to Abseil C++ standard
    # Issue ref: https://github.com/OpenLightingProject/ola/issues/1879
    inreplace "configure.ac", "-std=gnu++11", "-std=gnu++17"
    if ENV.compiler == :clang
      # Workaround until https://github.com/OpenLightingProject/ola/pull/1889
      ENV.append "CXXFLAGS", "-D_LIBCPP_ENABLE_CXX17_REMOVED_AUTO_PTR"
      # Workaround until https://github.com/OpenLightingProject/ola/pull/1890
      ENV.append "CXXFLAGS", "-D_LIBCPP_ENABLE_CXX17_REMOVED_BINDERS"
      ENV.append "CXXFLAGS", "-D_LIBCPP_ENABLE_CXX17_REMOVED_UNARY_BINARY_FUNCTION"
    end

    # Skip flaky python tests. Remove when no longer running tests
    inreplace "python/ola/Makefile.mk", /^test_scripts \+= \\$/, "skipped_test_scripts = \\"

    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources

    args = %W[
      --disable-fatal-warnings
      --disable-silent-rules
      --enable-unittests
      --enable-python-libs
      --enable-rdm-tests
      --with-python_prefix=#{libexec}
      --with-python_exec_prefix=#{libexec}
    ]

    ENV["PYTHON"] = venv.root/"bin/python"
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *args, *std_configure_args
    system "make"
    # Run tests to check the workarounds applied haven't broken basic functionality.
    # TODO: Remove and revert to `--disable-unittests` when workarounds can be dropped.
    system "make", "check"
    system "make", "install"

    rewrite_shebang python_shebang_rewrite_info(venv.root/"bin/python"), *bin.children
  end

  def caveats
    <<~EOS
      To use the bundled Python libraries:
        #{Utils::Shell.export_value("PYTHONPATH", extra_python_path)}
    EOS
  end

  test do
    ENV.prepend_path "PYTHONPATH", extra_python_path
    system bin/"ola_plugin_state", "-h"
    system python3, "-c", "from ola.ClientWrapper import ClientWrapper"
  end
end
