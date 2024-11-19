class RancherCli < Formula
  desc "Unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "d44358847d6f25bb185f79cb1f8ef8b91ba644b29dc2832e593f31b98fd49765"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d72b61b1c6a8278d1663edfc9775ed64fa2375a728462cd541a8e89da91c569a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d72b61b1c6a8278d1663edfc9775ed64fa2375a728462cd541a8e89da91c569a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d72b61b1c6a8278d1663edfc9775ed64fa2375a728462cd541a8e89da91c569a"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d4ec9d2baef93bf960cfca6200809a7444117b19d6a930b99ad2efe0322b9d9"
    sha256 cellar: :any_skip_relocation, ventura:       "9d4ec9d2baef93bf960cfca6200809a7444117b19d6a930b99ad2efe0322b9d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4f38f7c08aa6dc3e2616602bdea83e13b3737e20e09710f83ea1ead1b2159ae"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=#{version}"), "-o", bin/"rancher"
  end

  test do
    assert_match "Failed to parse SERVERURL", shell_output("#{bin}/rancher login localhost -t foo 2>&1", 1)
    assert_match "invalid token", shell_output("#{bin}/rancher login https://127.0.0.1 -t foo 2>&1", 1)
  end
end
