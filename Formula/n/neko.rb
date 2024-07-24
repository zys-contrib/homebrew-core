class Neko < Formula
  desc "High-level, dynamically typed programming language"
  homepage "https://nekovm.org/"
  url "https://github.com/HaxeFoundation/neko/archive/refs/tags/v2-4-0.tar.gz"
  version "2.4.0"
  sha256 "232d030ce27ce648f3b3dd11e39dca0a609347336b439a4a59e9a5c0a465ce15"
  license "MIT"
  head "https://github.com/HaxeFoundation/neko.git", branch: "master"

  bottle do
    sha256                               arm64_sonoma:   "5df554d5b13e35244da52a836eb57f2f0c060db5af7389d08b7cc483aa30e22e"
    sha256                               arm64_ventura:  "7884de8412bd4275f2ad1d64391b7b42c3c816143a8ae6f13b268bb2e9aa29a4"
    sha256                               arm64_monterey: "5c98fefc1af0c5b4391c48c2c28957f3b11e635b4f6fdf2b8a274a9b3d71c6fc"
    sha256                               arm64_big_sur:  "7dc2386e227172ce35a3c01583bcac98793e3477f23ac0dd764514fb1ad8126d"
    sha256                               sonoma:         "c313dc45e64b718ca4b65a7d60fa34e667c9d196a1a3f155d4988abfd2a410b8"
    sha256                               ventura:        "41e4b5cafe8330cabb6fb97ec386beb2a0390a2f89a2d91a3c0ff325d3cdba7b"
    sha256                               monterey:       "25484b429d41aba93aed15be888c59bcf33247936c2fc0bfc4aa657324aaee7e"
    sha256                               big_sur:        "c58be5fa39965347a20657f83e980e6a8b92c055b47e2425c1cd4ee228d76f9b"
    sha256                               catalina:       "a6d4dfa77a8de46e49eb8cad58fd2423f6e0c57fc6788941bef81ea9abc02ad2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b85cdf1112098a5bb933676765efd29c446cf58a994f02e914b113681e84009"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "bdw-gc"
  depends_on "mbedtls"
  depends_on "mysql-client"
  depends_on "pcre2"
  depends_on "zlib" # due to `mysql-client`

  uses_from_macos "sqlite"

  on_linux do
    depends_on "apr"
    depends_on "apr-util"
    depends_on "gtk+3" # On mac, neko uses carbon. On Linux it uses gtk3
    depends_on "httpd"
  end

  def install
    args = %w[
      -DRELOCATABLE=OFF
      -DRUN_LDCONFIG=OFF
    ]
    if OS.linux?
      args << "-DAPR_LIBRARY=#{Formula["apr"].opt_lib}"
      args << "-DAPR_INCLUDE_DIR=#{Formula["apr"].opt_include}/apr-1"
      args << "-DAPRUTIL_LIBRARY=#{Formula["apr-util"].opt_lib}"
      args << "-DAPRUTIL_INCLUDE_DIR=#{Formula["apr-util"].opt_include}/apr-1"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    s = ""
    if HOMEBREW_PREFIX.to_s != "/usr/local"
      s << <<~EOS
        You must add the following line to your .bashrc or equivalent:
          export NEKOPATH="#{HOMEBREW_PREFIX}/lib/neko"
      EOS
    end
    s
  end

  test do
    ENV["NEKOPATH"] = "#{HOMEBREW_PREFIX}/lib/neko"
    system "#{bin}/neko", "-version"
    (testpath/"hello.neko").write '$print("Hello world!\n");'
    system "#{bin}/nekoc", "hello.neko"
    assert_equal "Hello world!\n", shell_output("#{bin}/neko hello")
  end
end
