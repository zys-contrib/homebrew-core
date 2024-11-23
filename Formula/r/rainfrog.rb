class Rainfrog < Formula
  desc "Database management TUI for Postgres"
  homepage "https://github.com/achristmascarl/rainfrog"
  url "https://github.com/achristmascarl/rainfrog/archive/refs/tags/v0.2.10.tar.gz"
  sha256 "fbcbd03fd92a43a34e2090fe776fc241d253e254c3ced91f18bb7b2328ea307d"
  license "MIT"
  head "https://github.com/achristmascarl/rainfrog.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # rainfrog is a TUI application
    assert_match version.to_s, shell_output("#{bin}/rainfrog --version")
  end
end
