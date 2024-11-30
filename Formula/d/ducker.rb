class Ducker < Formula
  desc "Slightly quackers Docker TUI based on k9s"
  homepage "https://github.com/robertpsoane/ducker"
  url "https://github.com/robertpsoane/ducker/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "2e368e2ba2b1df5f33c112caef2da5788c06c3b181e0b382f94b1b97478160cd"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/ducker --export-default-config 2>&1", 1)
    assert_match "failed to create docker connection", output

    assert_match "ducker #{version}", shell_output("#{bin}/ducker --version")
  end
end
