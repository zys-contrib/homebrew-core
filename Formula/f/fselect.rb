class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/refs/tags/0.8.9.tar.gz"
  sha256 "08a903e2bd7d68dff004a6552dc5823989c74ce20a96416601ce7002f6b51a7b"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "d1028fcca660a0a1876cd8ad5d92314dff3ee6fef54fb10bffc59cabfc9c1dc8"
    sha256 cellar: :any,                 arm64_sonoma:  "a9acdc57d9a524f57854fcc56baeb3424bcc9df9312f90e32a6d1154d35ea9bd"
    sha256 cellar: :any,                 arm64_ventura: "dfebd2f2eb389bb277d9d36891d6119bec6874c6b7d3a1ebf2fdd9ec924c9cf1"
    sha256 cellar: :any,                 sonoma:        "3244d215731477c373e75589d09c48e408fe17c52b97412beb92a774de8ae920"
    sha256 cellar: :any,                 ventura:       "d93fa6b4d3a3e8e04a79f3c14423e8e6b5c4291c873c4c66c04b0bd0beb4911c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cda28ae154ab74d840102f543cbab87ca90e53f03d60e907cb9f7209e80042d0"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "libgit2"

  uses_from_macos "bzip2"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    require "utils/linkage"

    touch testpath/"test.txt"
    cmd = "#{bin}/fselect name from . where name = '*.txt'"
    assert_match "test.txt", shell_output(cmd).chomp

    linked_libraries = [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
    ]
    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin/"fselect", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
