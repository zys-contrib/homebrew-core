class Convco < Formula
  desc "Conventional commits, changelog, versioning, validation"
  homepage "https://convco.github.io"
  url "https://github.com/convco/convco/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "6f8e58f8572a785e32d287cad80d174303a5db5abc4ce0cf50022e05125549dd"
  license "MIT"
  head "https://github.com/convco/convco.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fdd240ce031cde57493cc4840d1a28094d00c6bb809865992dffff04c049ef38"
    sha256 cellar: :any,                 arm64_sonoma:  "1501858eeb3eb0f287004aeba9fb10682f61721a65fccd01d0a82666caabf1b1"
    sha256 cellar: :any,                 arm64_ventura: "10ef832098713702847732101646118cfdbe5f9651751369ca799328f1bca2d4"
    sha256 cellar: :any,                 sonoma:        "855873ef6a533b75c898d5a8d7c323e8bfbe3f204b2b84e929e17a37ac73f146"
    sha256 cellar: :any,                 ventura:       "fafefae755cafaf4606a1bb90b1fd0aedad9ed84fee875d68e58e87ea1b6c04e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53887102d0b72408953eb08c56e2ac11074b2c6db15d4d292f3996d0073388d7"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", "--no-default-features", *std_cargo_args

    bash_completion.install "target/completions/convco.bash" => "convco"
    zsh_completion.install  "target/completions/_convco" => "_convco"
    fish_completion.install "target/completions/convco.fish" => "convco.fish"
  end

  test do
    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "invalid"
    assert_match(/FAIL  \w+  first line doesn't match `<type>\[optional scope\]: <description>`  invalid\n/,
      shell_output("#{bin}/convco check", 1).lines.first)

    # Verify that we are using the libgit2 library
    linkage_with_libgit2 = (bin/"convco").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_lib/shared_library("libgit2")).realpath.to_s
    end
    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end
