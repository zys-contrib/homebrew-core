class Favirecon < Formula
  desc "Uses favicon.ico to improve the target recon phase"
  homepage "https://github.com/edoardottt/favirecon"
  url "https://github.com/edoardottt/favirecon/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "f86508313ece963c8bd173561bf2d3e98fd995a762acc2f8e4a071f695e6759d"
  license "MIT"
  head "https://github.com/edoardottt/favirecon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40f67c348cd32b50b8d6f27c933ff620153503030a5cc12eb38b50fa242de30e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40f67c348cd32b50b8d6f27c933ff620153503030a5cc12eb38b50fa242de30e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "40f67c348cd32b50b8d6f27c933ff620153503030a5cc12eb38b50fa242de30e"
    sha256 cellar: :any_skip_relocation, sonoma:        "8bc2f04831805761b2c04c30507f59c0b7622334cadfaeacba1d6a5f7de6ec0e"
    sha256 cellar: :any_skip_relocation, ventura:       "8bc2f04831805761b2c04c30507f59c0b7622334cadfaeacba1d6a5f7de6ec0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53e98be9e8cb6265734b57e242db0966079d444498adf9d4387ac6bb3d83d8ec"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/favirecon"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/favirecon --help")

    output = shell_output("#{bin}/favirecon -u https://www.github.com -verbose 2>&1")
    assert_match "Checking favicon for https://www.github.com/favicon.ico", output
  end
end
