class RancherCli < Formula
  desc "Unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/refs/tags/v2.11.2.tar.gz"
  sha256 "6e8fea75ba3f6584e10edeab4db53e15453677ee80489b2d550c96eda5c2ef85"
  license "Apache-2.0"
  head "https://github.com/rancher/cli.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c33ea7a5b435e9686e08424fba51d70da6cbbd627382c579256a8bd5fb5b029f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c33ea7a5b435e9686e08424fba51d70da6cbbd627382c579256a8bd5fb5b029f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c33ea7a5b435e9686e08424fba51d70da6cbbd627382c579256a8bd5fb5b029f"
    sha256 cellar: :any_skip_relocation, sonoma:        "fae467f616e7b2e8d6274ef78959cdd7d35106375e71cadabf54b8637b150ab7"
    sha256 cellar: :any_skip_relocation, ventura:       "fae467f616e7b2e8d6274ef78959cdd7d35106375e71cadabf54b8637b150ab7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c28675649a3395b3e53569757f5c2be7605d3d338da58ea96f93cfac9e21cd2c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=#{version}", output: bin/"rancher")
  end

  test do
    assert_match "Failed to parse SERVERURL", shell_output("#{bin}/rancher login localhost -t foo 2>&1", 1)
    assert_match "invalid token", shell_output("#{bin}/rancher login https://127.0.0.1 -t foo 2>&1", 1)
  end
end
