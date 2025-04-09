class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https://github.com/alexpasmantier/television"
  url "https://github.com/alexpasmantier/television/archive/refs/tags/0.11.6.tar.gz"
  sha256 "b11448160d897bbb05fdf62385efe1436abffe60547d0692cb4b1c9f23fd9827"
  license "MIT"
  head "https://github.com/alexpasmantier/television.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "deca33b67631e6065d92c3a9a3d0e6cdc5b436c8092a92838ca813c88684bd11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93e55a7282a94544d05d3050189025768e10601277e8db94fa269121fe289dc0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0bdb7938edbe36778c474cf7bf14cc16870cf5fceba3335c44c404fc85e5a666"
    sha256 cellar: :any_skip_relocation, sonoma:        "c48e4329f14952926544264d523aa5198319ea72e9021978eabf245aa6944e0b"
    sha256 cellar: :any_skip_relocation, ventura:       "00474c00408cf8229e0be1287d9a237cf8811cee3b08c8796b378ea48647c6a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f444d03cb83cc71253cb15721796cc4c9bda0370cd6c96cc17ba3c10f5ac64e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f832beecb5b6a0daeddc4de9881b4f3d850c4df6c51fb4cd76598a81c0a1fa1a"
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
