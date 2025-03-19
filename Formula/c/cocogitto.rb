class Cocogitto < Formula
  desc "Conventional Commits toolbox"
  homepage "https://docs.cocogitto.io/"
  url "https://github.com/cocogitto/cocogitto/archive/refs/tags/6.3.0.tar.gz"
  sha256 "bf78a06ec20cd33c4f9bcddb427067de34d005fb6d4a41727239b7b1e8e916e0"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "27fbf4df39907711ecc2c82abe07b3c689c876aae77aa5d325bcd9e9b007a7c8"
    sha256 cellar: :any,                 arm64_sonoma:  "63ca3e4a49d901c0081a84fadbcc1c5c987cadf9d625f083c04c4f55cf5efde8"
    sha256 cellar: :any,                 arm64_ventura: "95c4df0d2711c35731a3cd661220c2ad34f2fd286915b01910d70513088bdb07"
    sha256 cellar: :any,                 sonoma:        "79a4836653fa8d60418233598b0b9a3f26c9eb25aaf33031dd4015cb555cfab9"
    sha256 cellar: :any,                 ventura:       "bd5e839eb51f908c4986ac50cc7e437e3156ee3aec13b167f4c615a503fe8be2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d6c7bb4b0c937d23a8f7131d1df5fa8d129bb2fc98cd68ce5e987a3be79c841"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  conflicts_with "cog", because: "both install `cog` binaries"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"cog", "generate-completions")

    system bin/"cog", "generate-manpages", buildpath
    man1.install Dir["*.1"]
  end

  test do
    # Check that a typical Conventional Commit is considered correct.
    system "git", "init", "--initial-branch=main"
    (testpath/"some-file").write("")
    system "git", "add", "some-file"
    system "git", "config", "user.name", "'A U Thor'"
    system "git", "config", "user.email", "author@example.com"
    system "git", "commit", "-m", "chore: initial commit"
    assert_equal "No errored commits", shell_output("#{bin}/cog check 2>&1").strip

    linkage_with_libgit2 = (bin/"cog").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end
