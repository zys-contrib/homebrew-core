class GitAbsorb < Formula
  desc "Automatic git commit --fixup"
  homepage "https://github.com/tummychow/git-absorb"
  url "https://github.com/tummychow/git-absorb/archive/refs/tags/0.6.15.tar.gz"
  sha256 "630e61a6edf1e244c38145bda98a522217c34d3ab70a3399af1f29f19e7ced26"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "692e781c789759f5543d82249f6a2f3aa1fd9a5cb5767febc1de7da40b78b094"
    sha256 cellar: :any,                 arm64_ventura:  "45c2125cb0c3b9d47f7abccfd3d3d1f2082efe47787d528516e5b0e4e0027965"
    sha256 cellar: :any,                 arm64_monterey: "c766bbae35c8028e3a0f95c5bbaf45afc087f388fc9f4f4602fdeac943627657"
    sha256 cellar: :any,                 sonoma:         "5783a344b2566b260de4504535f07e413f3b82bf639ca8235ff4f12a0f878c5d"
    sha256 cellar: :any,                 ventura:        "fb2c8d07ccdf26ac85a051850b05a92b2d310ebf74151e5835405ab18b28d4c6"
    sha256 cellar: :any,                 monterey:       "e2666b55a0dffaa0fcb274864a701a74249571fd8be1695cc858cf4409c0a03e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39673972c771d85604ca86862e6e5bb2de77bd3c57b1243aca69b914238b6373"
  end

  depends_on "pkg-config" => :build
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
