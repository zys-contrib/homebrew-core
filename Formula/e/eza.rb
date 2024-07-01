class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://github.com/eza-community/eza"
  url "https://github.com/eza-community/eza/archive/refs/tags/v0.18.21.tar.gz"
  sha256 "53cee12706be2b5bedcf40b97e077a18b254f0f53f1aee52d1d74136466045bc"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d12d9b7c8b63cd3c058fee0fe6fe55d38b40dc1c1b299727b56d9aefb8a9e8a6"
    sha256 cellar: :any,                 arm64_ventura:  "58309e18570fb61f85075566e4422cca4a8ccf4157387715ca22d41bfc6adbc3"
    sha256 cellar: :any,                 arm64_monterey: "799cf7743ef7f2311e474770c6c94eaa95dd649dcc3b9853669871b4cf8c44c2"
    sha256 cellar: :any,                 sonoma:         "d362540612ba4022aa63f2fccdadc119accebc534fb43f80a2520f83ba359e7e"
    sha256 cellar: :any,                 ventura:        "6c2893114950b22bc2aba64904a147321ca1f1d5d8737dc5fd7154bd53237da2"
    sha256 cellar: :any,                 monterey:       "51e81b6017418f99c82d7e0091af93b04d76785f3e8f4ae907fd71bb9345cc9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bdafde1b7348ae8821dca062196a3890265a6d10fa2a1eb8c15069676d32aea"
  end

  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/bash/eza"
    fish_completion.install "completions/fish/eza.fish"
    zsh_completion.install  "completions/zsh/_eza"

    args = %w[
      --standalone
      --from=markdown
      --to=man
    ]
    system "pandoc", *args, "man/eza.1.md", "-o", "eza.1"
    system "pandoc", *args, "man/eza_colors.5.md", "-o", "eza_colors.5"
    system "pandoc", *args, "man/eza_colors-explanation.5.md", "-o", "eza_colors-explanation.5"

    man1.install buildpath.glob("*.1")
    man5.install buildpath.glob("*.5")
  end

  test do
    testfile = "test.txt"
    touch testfile
    assert_match testfile, shell_output(bin/"eza")

    # Test git integration
    flags = "--long --git --no-permissions --no-filesize --no-user --no-time --color=never"
    eza_output = proc { shell_output("#{bin}/eza #{flags}").lines.grep(/#{testfile}/).first.split.first }
    system "git", "init"
    assert_equal "-N", eza_output.call
    system "git", "add", testfile
    assert_equal "N-", eza_output.call
    system "git", "commit", "-m", "Initial commit"
    assert_equal "--", eza_output.call

    linkage_with_libgit2 = (bin/"eza").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end
