class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https://github.com/alexpasmantier/television"
  url "https://github.com/alexpasmantier/television/archive/refs/tags/0.11.2.tar.gz"
  sha256 "c5cd3ac1b5b49b8fc36fab9764cb9cfa5681b94c0ddbc4ed6133872ecaffde7c"
  license "MIT"
  head "https://github.com/alexpasmantier/television.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a48faec41cb35e85a96b074bb2e07c2531ee056e52e70f418fc3480ffb64cd27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bab1597fbe3647bb12bf947f3512a9a1194cce2658b7b5cd994f44cbce19528c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "abd8a46ca808a451a414f332a57ce4b1c8fd8131fcb907ce55e40e52249f4471"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fca1c3bb0d33576638438e2735b57696952d0cf0916ecc940a5c7af238f038c"
    sha256 cellar: :any_skip_relocation, ventura:       "66fddee64ce35625b3e068f7fcb869623df392214ae8ec784df7f68e59439bfe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d16a96257af5148b1f6e5a573ba77024be0f61e029ec9b5880a1312171ace420"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c8ef047ab04ac64afabac215d899ce68f54edc15ad81f2a294bf9dc65ea65e3"
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
