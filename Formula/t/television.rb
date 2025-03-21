class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https://github.com/alexpasmantier/television"
  url "https://github.com/alexpasmantier/television/archive/refs/tags/0.11.2.tar.gz"
  sha256 "c5cd3ac1b5b49b8fc36fab9764cb9cfa5681b94c0ddbc4ed6133872ecaffde7c"
  license "MIT"
  head "https://github.com/alexpasmantier/television.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c899bc1c65af1603a7394f3f6d0e18ca3e430707983c2338df0700662ba6fae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e114f99053afbcb7b5de260f90488d9212214ce8ba907e6899f229b8426f787"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "91f10e2cd21cec663341928a431a1769c6bec526c5a91c12c4091584fca6d3dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "007f607c382b35d71f5f69f33e47e6464bea87d936132aee69cd0d26e27b6131"
    sha256 cellar: :any_skip_relocation, ventura:       "ae17679fb7fd742b0c5a7043cffd45af5a061a3bf5bc0cc5252cec2c85f4baf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9afd21d4fa9654cdd4976fcafcd54140a017b2f3dda9905a89d52d50fbc58d2"
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
