class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.26.3.tar.gz"
  sha256 "3df07ca307b77c9def8d6afc32bc96bd5516398042d54bc095560c1b49a38089"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1f281644bf0bf317df20c31f6b14c5c199905dda64446ff68aa5c500e0881505"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f05475ee20ee02567d882c698ea08b506557a8efd07f2cebc30ffd60e19074d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b94ec0b0bb17c0352220f8728614826f47a0d049d8ee848fe433a2059675ec7"
    sha256 cellar: :any_skip_relocation, sonoma:         "d58178207435ddd73fb996e410a204d424fc4807f7f4b2586f88c36bd5cfc2a7"
    sha256 cellar: :any_skip_relocation, ventura:        "5496439fcd8ab4f732557b527473cdbff94f5cab18bd5c2ba049f0249cebe8a9"
    sha256 cellar: :any_skip_relocation, monterey:       "aa64027258bbdb80570e8f9bcdbd0dad26f29ca3b240b60441ee69f9dfc9a002"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92ead80525c3a4fd205c3549c58cf7a45645aee4cc6c039a7fddc18778dcfea1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"ast-grep", "completions")
    generate_completions_from_executable(bin/"sg", "completions")
  end

  test do
    (testpath/"hi.js").write("console.log('it is me')")
    system bin/"sg", "run", "-l", "js", "-p console.log", (testpath/"hi.js")

    assert_match version.to_s, shell_output("#{bin}/ast-grep --version")
  end
end
