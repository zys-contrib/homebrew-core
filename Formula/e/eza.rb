class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://github.com/eza-community/eza"
  url "https://github.com/eza-community/eza/archive/refs/tags/v0.20.16.tar.gz"
  sha256 "be5eb8d314f817bbfdcad4d21e66d2a8c4006ba4619735297b5233887ebdbe99"
  license "EUPL-1.2"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "55c6c9d272929f739343123f40060696d3feaf7c14d1c1acb70972d47f1e38aa"
    sha256 cellar: :any,                 arm64_sonoma:  "e72f8a8d3a3a8907fee79ffca57ec20758ac989ef927a9306b43648cb60f311f"
    sha256 cellar: :any,                 arm64_ventura: "04b6296f15d56e106778b621163829f24d83e6d34c3891c91560210cbfef62f7"
    sha256 cellar: :any,                 sonoma:        "22b0c6b0f0c3600a455468924cd38ca5a781e6e255c82998034c63cb3f168adf"
    sha256 cellar: :any,                 ventura:       "2b39d3a516e84eb9d22886d8acd3a7573a9f4f2bb08f338a9f0b0ce24805210d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2109d06eb6c10d8212a52cb4c5914d46014de699c74394cebbd0d805f7158d7e"
  end

  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build
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
