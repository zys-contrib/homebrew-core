class Gfold < Formula
  desc "Help keep track of your Git repositories, written in Rust"
  homepage "https://github.com/nickgerace/gfold"
  url "https://github.com/nickgerace/gfold/archive/refs/tags/2025.2.1.tar.gz"
  sha256 "f4bfb2c69da1f2e1a70713b316c2befef553039bc7248594f8f990115a66cc33"
  license "Apache-2.0"
  head "https://github.com/nickgerace/gfold.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c8fb05b44e4e1463813e968cd143c5e75058a3bc68a21be4d6000a70181ab721"
    sha256 cellar: :any,                 arm64_sonoma:  "e5a04e5a6969aa68a5d91e9205a93910a84317d5570a41e1115f26a23bdf62e8"
    sha256 cellar: :any,                 arm64_ventura: "71d2cf8716fc3e10d1fce289ae2f10c7c533775a27f1e0eace914d525fcf7a4d"
    sha256 cellar: :any,                 sonoma:        "cd2484f7a149a5cac2708ae97de755e25f85f776bde43b3fc77bf88480bb2c38"
    sha256 cellar: :any,                 ventura:       "f2cd2b75deb9e7194a9c6e7b0f1cc2e83095d629fe257e0f9f2f8b5e1430effb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec6098aad7b88db6c94eb6773a5c2a1e67d08e60d44736ab5af143ca8734f6f8"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  uses_from_macos "zlib"

  conflicts_with "coreutils", because: "both install `gfold` binaries"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    mkdir "test" do
      system "git", "config", "--global", "init.defaultBranch", "master"
      system "git", "init"
      Pathname("README").write "Testing"
      system "git", "add", "README"
      system "git", "commit", "-m", "init"
    end

    assert_match "\e[0m\e[32mclean\e[0m (master)", shell_output("#{bin}/gfold #{testpath} 2>&1")

    # libgit2 linkage test to avoid using vendored one
    # https://github.com/Homebrew/homebrew-core/pull/125393#issuecomment-1465250076
    linkage_with_libgit2 = (bin/"gfold").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."

    assert_match "gfold #{version}", shell_output("#{bin}/gfold --version")
  end
end
