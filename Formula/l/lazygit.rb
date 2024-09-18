class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/refs/tags/v0.44.1.tar.gz"
  sha256 "02b67d38e07ae89b0ddd3b4917bd0cfcdfb5e158ed771566d3eb81f97f78cc26"
  license "MIT"
  head "https://github.com/jesseduffield/lazygit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9380c3f904029f350d15ee734a49ca4c0781b72e17425454ee13151e0d7f711e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9380c3f904029f350d15ee734a49ca4c0781b72e17425454ee13151e0d7f711e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9380c3f904029f350d15ee734a49ca4c0781b72e17425454ee13151e0d7f711e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9380c3f904029f350d15ee734a49ca4c0781b72e17425454ee13151e0d7f711e"
    sha256 cellar: :any_skip_relocation, sonoma:         "47addef592a55c5c731473a93d3019298eb6c66ac6fe681908016d507aa45774"
    sha256 cellar: :any_skip_relocation, ventura:        "47addef592a55c5c731473a93d3019298eb6c66ac6fe681908016d507aa45774"
    sha256 cellar: :any_skip_relocation, monterey:       "47addef592a55c5c731473a93d3019298eb6c66ac6fe681908016d507aa45774"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95fa048ada940b91e05ae1de55946fb861743bc7be476ee2fbce4ee9541313d8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -X main.buildSource=homebrew"
    system "go", "build", "-mod=vendor", *std_go_args(ldflags:)
  end

  test do
    system "git", "init", "--initial-branch=main"

    output = shell_output("#{bin}/lazygit log 2>&1", 1)
    assert_match "errors.errorString terminal not cursor addressable", output

    assert_match version.to_s, shell_output("#{bin}/lazygit -v")
  end
end
