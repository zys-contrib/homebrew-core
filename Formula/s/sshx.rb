class Sshx < Formula
  desc "Fast, collaborative live terminal sharing over the web"
  homepage "https://sshx.io"
  url "https://github.com/ekzhang/sshx/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "ab6de41546b849726faa3b964466c1f8bb558bd27ee2452a9758405ff013108f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9b2707c6e2ce7a7345cec772567120e76346d027b1a34448dabadd91b2264f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03a8e2ca793e445d3d6404da2045fcb67f63c908d45fe7029f561dc73dd4aef6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "35f7f780c005259b54a859dab66c64c3318a3dc6960b97e125bc35e06d13b6b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff39dc85317b63e1d69fb5b936800e76c1e3fc2d04a0ee8fecf717ba337244f0"
    sha256 cellar: :any_skip_relocation, ventura:       "e67a3e6f530202c8cb2f134dd4be881ee9ca0f4261de15903998990710475ad9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3c70772d764157fb8f96af281fabe1418f92fd46b84e495ca74f83b75ce79fa"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/sshx")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sshx --version")

    begin
      process = IO.popen "#{bin}/sshx --quiet"
      sleep 1
      Process.kill "TERM", process.pid
      assert_match "https://sshx.io/s/", process.read
    ensure
      Process.wait process.pid
    end
  end
end
