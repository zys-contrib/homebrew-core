class Codesnap < Formula
  desc "Generates code snapshots in various formats"
  homepage "https://github.com/mistricky/CodeSnap"
  url "https://github.com/mistricky/CodeSnap/archive/refs/tags/v0.10.5.tar.gz"
  sha256 "f9ba0e36aab5c671f8068ca0d7bbd3cab4432f72096dbc6c425f4aaf9bc1b780"
  license "MIT"
  head "https://github.com/mistricky/CodeSnap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f93f71c3da352d8ed558e39a2dddb061ce5e18906335c688ca2912f7b9a0b014"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4023ba270b4e82f1f276aacd01138a8c9dd1433bad4aff7225b877b905683b04"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6fce19304f93c9b602ee0277a7a72ff50c999a07bdb1ecd39877dfd72837ab2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a2d5dc122fc16fd9d1d8eb942733ef94778c4afc85468d686c4a282c35362ff"
    sha256 cellar: :any_skip_relocation, ventura:       "32f11308ee6ef880b5a9473daabcb8843f879e495a875418ea8a4baef5b6c11a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51d6c84fb761fb42295c46bb601595e4757f3ed4e77521b00b1a4b12114863f3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")

    pkgshare.install "cli/examples"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codesnap --version")

    # Fails in Linux CI with "no default font found"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "SUCCESS", shell_output("#{bin}/codesnap -f #{pkgshare}/examples/cli.sh -o cli.png")
  end
end
