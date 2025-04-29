class Bibtexconv < Formula
  desc "BibTeX file converter"
  homepage "https://github.com/dreibh/bibtexconv"
  url "https://github.com/dreibh/bibtexconv/archive/refs/tags/bibtexconv-2.0.1.tar.gz"
  sha256 "b85d71000b5b41949adec1165138b68da2cd831da815ca64523dc9843b979c3c"
  license "GPL-3.0-or-later"
  head "https://github.com/dreibh/bibtexconv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "138a8763fdf7f0a8cb9176533994126cdd1ad4ad7d8235abd782140a9d52fb64"
    sha256 cellar: :any,                 arm64_sonoma:  "151028cf9b243d37292e4d4b93094be1f544fd0b201e7e19d62083179a6bcac9"
    sha256 cellar: :any,                 arm64_ventura: "fb2eb14d8a3481a48a7018d7b09f1e0abdcde2597599e0885534393c72e5dc8d"
    sha256 cellar: :any,                 sonoma:        "b29cf7e29d63c463e282975b9eaeb5bff6ad1fbe464f4db2959b95a386c4a909"
    sha256 cellar: :any,                 ventura:       "487f6fafa5555094d4ebfca0f2f2db644609f904fddd98e53b2c81b143adb85e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "661c36772b6b9456cbed2cca3a6920fa7f82c4e0643484b31eb02cc3e53e2e1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "421887563ca96e4fd3b6810015f7fd2b88293a9d3883063490e39b4acd4fc709"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "flex" => :build
  uses_from_macos "curl"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1500
  end

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1500

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DCRYPTO_LIBRARY=#{Formula["openssl@3"].opt_lib}/#{shared_library("libcrypto")}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    cp "#{opt_share}/doc/bibtexconv/examples/ExampleReferences.bib", testpath

    system bin/"bibtexconv", "#{testpath}/ExampleReferences.bib",
                             "-export-to-bibtex=UpdatedReferences.bib",
                             "-check-urls", "-only-check-new-urls",
                             "-non-interactive"
  end
end
