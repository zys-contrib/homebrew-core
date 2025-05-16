class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mattermost"
  url "https://github.com/mattermost/mattermost/archive/refs/tags/v10.8.0.tar.gz"
  sha256 "f7fd48a3bc9ee41fcaf70e8e1ef0841d9a7e17533f71eacd67de64021c95915c"
  license all_of: ["AGPL-3.0-only", "Apache-2.0"]
  head "https://github.com/mattermost/mattermost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ff49964cc573544dbd806fcd736ffca3dca9b1bac4290afd8c4781b46f06169"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ff49964cc573544dbd806fcd736ffca3dca9b1bac4290afd8c4781b46f06169"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6ff49964cc573544dbd806fcd736ffca3dca9b1bac4290afd8c4781b46f06169"
    sha256 cellar: :any_skip_relocation, sonoma:        "f19752a71fc5d4743e5bae14653ac5d5203d943fba1bdd3504cf36a66eff777f"
    sha256 cellar: :any_skip_relocation, ventura:       "f19752a71fc5d4743e5bae14653ac5d5203d943fba1bdd3504cf36a66eff777f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "932146d69f61e08440d70c6f19c4dcdb749fb821a9b7c86a48844687ed5bed16"
  end

  depends_on "go" => :build

  def install
    # remove non open source files
    rm_r("server/enterprise")

    ldflags = "-s -w -X github.com/mattermost/mattermost/server/v8/cmd/mmctl/commands.buildDate=#{time.iso8601}"
    system "make", "-C", "server", "setup-go-work"
    system "go", "build", "-C", "server", *std_go_args(ldflags:), "./cmd/mmctl"

    # Install shell completions
    generate_completions_from_executable(bin/"mmctl", "completion", shells: [:bash, :zsh])
  end

  test do
    output = pipe_output("#{bin}/mmctl help 2>&1")
    refute_match(/.*No such file or directory.*/, output)
    refute_match(/.*command not found.*/, output)
    assert_match(/.*mmctl \[command\].*/, output)
  end
end
