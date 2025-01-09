class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https://github.com/alexpasmantier/television"
  url "https://github.com/alexpasmantier/television/archive/refs/tags/0.9.2.tar.gz"
  sha256 "93f82f33e699a4a91f0015d88856a7fde5ae95bfa132a02c08518ddd264256cb"
  license "MIT"
  head "https://github.com/alexpasmantier/television.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d343b97a6be455920b282433f3fa15c277038c5f285fe783ce6df742f5562060"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8da8f93adbbbf6833b39ec3252d84259b165d8a58e477c47ccd1d1023462a43b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c1a25247ab8740e10d79fba54a0b4bc0ae845d8418514e81da7c732a6a115336"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fca20332ff48a3c6c8fab57bde9e691683282b05544b5f97a1c5ad4b06b9823"
    sha256 cellar: :any_skip_relocation, ventura:       "2c3dbc6869aaf3d646b0c278ab08003c2c2e31635a9c77b0cd087e65a2f0c357"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64262df75f93e3f5ca5a9582f0650f5e13f0cdb3aa541fc65df1a93b417fb07b"
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
