class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/refs/tags/0.8.7.tar.gz"
  sha256 "1c8c3edd76f483ce66ea9a2f925abd44fffc6234b35088ed50131ce7e6552c81"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1c3e8e52608993681362fa617f524a63d45684a4f7fa29f01b1a39a81598de74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3171b8c25d69f276f61be0c7cce9ab905e54ea4011a484e0ba9330a996352563"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de126c3169480e0d90144eaad355ed031b62aa2b8149a8a02c917414a0fc9f73"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f57d8cd7e8e943e316f3c143e11c76bc0263db43f756b6fcc1d1a15e556ca80e"
    sha256 cellar: :any_skip_relocation, sonoma:         "80b7ebca9ea3f802c5d0b489e7bcbc756e0c49d1894fc615c0fb7b71bc460caa"
    sha256 cellar: :any_skip_relocation, ventura:        "4f1fb5fea01dbec1ffef839f7f62ccfa99392dd079c69c561d2a04cc0f4d530b"
    sha256 cellar: :any_skip_relocation, monterey:       "9766a8bb7449d7ecacabcae13c0d780792323c435ee1852077d2249527b3d1e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1d2aa5853dadf6a50d4942b8258b50b7605ae4ad1d0d7b213d52c890128cc3b"
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
