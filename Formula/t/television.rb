class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https://github.com/alexpasmantier/television"
  url "https://github.com/alexpasmantier/television/archive/refs/tags/0.8.5.tar.gz"
  sha256 "33a0b683a6b7f9cc4ee7b0306fb392111a21c2cf37434716630c40e27722802a"
  license "MIT"
  head "https://github.com/alexpasmantier/television.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ac094ea6c2ab192ad84eb9c97ed40c2f63092bd52291efb7e982545452d2236"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "121e24cda9fcb20099a028fb8b65547fa7b4c411bd178033b1b33966066be2c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "de6253e7ac033a14ba52e939ee36d9f07307b10fadde172eeddc92f52e985735"
    sha256 cellar: :any_skip_relocation, sonoma:        "241ed52c6fa103a7102846b1755343b053d7b161a3131ccef636a687bdf06325"
    sha256 cellar: :any_skip_relocation, ventura:       "18fe7519bc8b0d80fe8cdd8b63dca72ad6fed8e896069216020d9ecc750febc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9de0d0250ed4045317ca76f86298d10faab2890125b0cc759bd3f3991ffd57a4"
  end

  depends_on "rust" => :build

  conflicts_with "tidy-viewer", because: "both install `tv` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tv -V")

    output = shell_output("#{bin}/tv list-channels")
    assert_match "Builtin channels", output
  end
end
