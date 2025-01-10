class GitAbsorb < Formula
  desc "Automatic git commit --fixup"
  homepage "https://github.com/tummychow/git-absorb"
  url "https://github.com/tummychow/git-absorb/archive/refs/tags/0.6.17.tar.gz"
  sha256 "512ef2bf0e642f8c34eb56aad657413bd9e04595e3bc4650ecf1c0799f148ca4"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "678f0567eda10a1341972c676ad3c9433269609d5d8aeb03d2d899b015b85df2"
    sha256 cellar: :any,                 arm64_sonoma:  "674145b9573fccdc080a3e61435cfe4e49f7ad939c48f58759ab088b3ce4decb"
    sha256 cellar: :any,                 arm64_ventura: "dda96ef119e6eabfe891707e7c049f0abb5ff6d9de1014597cc51ef5fa36febe"
    sha256 cellar: :any,                 sonoma:        "aeaf6c2d75dd48a3eef2595dceec1edefbd7724e9ccf9e1acbaf7ae48ac6e65a"
    sha256 cellar: :any,                 ventura:       "b7e617d3c205794b774a5ae137467e67ff1539f327ebedc1de287ad68b677e49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0821ca7fbac6b09e07df65c0f8e74a3a5f04f5ddbbe1fa87eb5de0f3ca0327c5"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    man1.install "Documentation/git-absorb.1"
    generate_completions_from_executable(bin/"git-absorb", "--gen-completions")
  end

  test do
    (testpath/".gitconfig").write <<~EOS
      [user]
        name = Real Person
        email = notacat@hotmail.cat
    EOS
    system "git", "init"
    (testpath/"test").write "foo"
    system "git", "add", "test"
    system "git", "commit", "--message", "Initial commit"

    (testpath/"test").delete
    (testpath/"test").write "bar"
    system "git", "add", "test"
    system "git", "absorb"

    linkage_with_libgit2 = (bin/"git-absorb").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end
