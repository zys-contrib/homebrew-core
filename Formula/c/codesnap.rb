class Codesnap < Formula
  desc "Generates code snapshots in various formats"
  homepage "https://github.com/mistricky/CodeSnap"
  url "https://github.com/mistricky/CodeSnap/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "035525441620da796283bef6ed2b12ea169be03238685b58d6a6da06ac28b28d"
  license "MIT"
  head "https://github.com/mistricky/CodeSnap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e26a5ca050ffefe64018abbbe080d72f8060f1d6f7a08200be6c8c9a4a9b9c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b89908c56f9855958235bdec0cdee94a470aa0311d0af58c8ee51b1d6b8d75da"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "42a06f4f6ee199187a2ed1de2046d7a7fd9c8ebce92822a0af32a477a1efb8ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "b00e63c3389865a4358f688d761398e1fdc68565c921c78b67a5685dea0c9bcf"
    sha256 cellar: :any_skip_relocation, ventura:       "dae89c29b118b02e8f6df4a1d6f9d67f6984f551585dffa8d359c88dfe27e347"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9497eeaab1e34c68d56eb2611535bbec29042f4f5a6be17a4382dcc6fb5a1327"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")

    pkgshare.install "examples"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codesnap --version")

    # Fails in Linux CI with "no default font found"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "SUCCESS", shell_output("#{bin}/codesnap -f #{pkgshare}/examples/cli.sh -o cli.png")
  end
end
