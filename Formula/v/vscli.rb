class Vscli < Formula
  desc "CLI/TUI that launches VSCode projects, with a focus on dev containers"
  homepage "https://github.com/michidk/vscli"
  url "https://github.com/michidk/vscli/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "5d3eed6c34541fca9f98d766a94b287f648af43d219d68e8546f9862abc34259"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vscli --version")

    output = pipe_output("#{bin}/vscli open --dry-run 2>&1")
    assert_match "No dev container found, opening on host system with code..", output
  end
end
