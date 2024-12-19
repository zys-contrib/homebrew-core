class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/refs/tags/0.8.8.tar.gz"
  sha256 "0f586c3870a66d4a3ab7b92409dcf0f68a23bd8031ec0cc3f1622efebe190c9e"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "635cc6bf9ec6150b7ad2c830784bf9c355e43f71185f52bbfac52b85b846e9e9"
    sha256 cellar: :any,                 arm64_sonoma:  "def92d68eae8e0e2ab27616249881a3a44422685437c59339252f9bb30a06bb4"
    sha256 cellar: :any,                 arm64_ventura: "29da5e91b89c88056252781d833a90585258f0627b7876c824a99afcd06a5fd5"
    sha256 cellar: :any,                 sonoma:        "c6906bcc37cdb1655200be35bbdd81e4a112e24dbd2d8adb04230b4b440d0abd"
    sha256 cellar: :any,                 ventura:       "2409c00563d73521f3e9f4d2bd2f2a17229aff1a5566125d0e8109fbe3f62d12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b8d9c40d9f4f98abd4ac135cf3ddca27b9c0e61442497c6e4a3d3bb3405075f"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    touch testpath/"test.txt"
    cmd = "#{bin}/fselect name from . where name = '*.txt'"
    assert_match "test.txt", shell_output(cmd).chomp

    linked_libraries = [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ]
    linked_libraries << (Formula["openssl@3"].opt_lib/shared_library("libcrypto")) if OS.mac?
    linked_libraries.each do |library|
      assert check_binary_linkage(bin/"fselect", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
