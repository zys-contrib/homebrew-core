class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https://mindersec.github.io/"
  url "https://github.com/mindersec/minder/archive/refs/tags/v0.0.68.tar.gz"
  sha256 "75f7bd3a9be5c404a53d6df33cc747a1c4158e1a0183fc8cbe4deeb3281c3835"
  license "Apache-2.0"
  head "https://github.com/mindersec/minder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dac924fd7db34ffd16c162eb045f84cc38daffca8509323e9a915af72ae65353"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dac924fd7db34ffd16c162eb045f84cc38daffca8509323e9a915af72ae65353"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dac924fd7db34ffd16c162eb045f84cc38daffca8509323e9a915af72ae65353"
    sha256 cellar: :any_skip_relocation, sonoma:        "1423869a79be21fbe2d819edd49ffdb628143839924be38a7b18b4197808e83a"
    sha256 cellar: :any_skip_relocation, ventura:       "30489450064f3e900596afbbc7a48916ef323b0f8a1460ebe7301889bc91c33a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64bbe4db89e2c67adf29a91e886d5b5fb174fd45a8c826e95892f4b78d5fe979"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/mindersec/minder/internal/constants.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"minder", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minder version")

    output = shell_output("#{bin}/minder artifact list -p github 2>&1", 16)
    assert_match "No config file present, using default values", output
  end
end
