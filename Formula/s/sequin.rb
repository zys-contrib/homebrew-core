class Sequin < Formula
  desc "Human-readable ANSI sequences"
  homepage "https://github.com/charmbracelet/sequin"
  url "https://github.com/charmbracelet/sequin/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "545b43475cd217465dbf5e620fb7bc129fca532ef768a1b51cfc1f11d8e98d4b"
  license "MIT"
  head "https://github.com/charmbracelet/sequin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "809be5b62e9e1c4afa7387c7eef4ecc59076a7638a7e5025fcf2debdcb2242d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "809be5b62e9e1c4afa7387c7eef4ecc59076a7638a7e5025fcf2debdcb2242d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "809be5b62e9e1c4afa7387c7eef4ecc59076a7638a7e5025fcf2debdcb2242d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "60a7d172d0a73886457f1de58e443f15beb3e291eec974caef85d241d1cf70cf"
    sha256 cellar: :any_skip_relocation, ventura:       "60a7d172d0a73886457f1de58e443f15beb3e291eec974caef85d241d1cf70cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4f9789f45c52ffc2b2c4890cc244d2da0c997aa71bce8f6c7632f621aab77e2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sequin -v")

    assert_match "CSI m: Reset style", pipe_output(bin/"sequin", "\x1b[m")
  end
end
