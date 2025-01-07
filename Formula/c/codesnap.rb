class Codesnap < Formula
  desc "Generates code snapshots in various formats"
  homepage "https://github.com/mistricky/CodeSnap"
  url "https://github.com/mistricky/CodeSnap/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "acb3e160039c9986f4566f3504df2c820558e62b7a412d4fd5030008f2c44f81"
  license "MIT"
  head "https://github.com/mistricky/CodeSnap.git", branch: "main"

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
