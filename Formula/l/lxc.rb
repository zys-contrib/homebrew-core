class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://ubuntu.com/lxd"
  url "https://github.com/canonical/lxd/releases/download/lxd-6.3/lxd-6.3.tar.gz"
  sha256 "68b379e94884f859fbfe078e4c0a46322ffd6f23209fa0b28d936676e7eada4d"
  license "AGPL-3.0-only"
  head "https://github.com/canonical/lxd.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c34c134ebc906cb32b382fd05c246a7158901cf4c9bebc23d52bec45b7b6def0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c34c134ebc906cb32b382fd05c246a7158901cf4c9bebc23d52bec45b7b6def0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c34c134ebc906cb32b382fd05c246a7158901cf4c9bebc23d52bec45b7b6def0"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b56f98a046cb2532c939d3cf390ee1953544ceed361437a180cafb11bdb0d9f"
    sha256 cellar: :any_skip_relocation, ventura:       "9b56f98a046cb2532c939d3cf390ee1953544ceed361437a180cafb11bdb0d9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f303552a55818faf6627e9d0c5cad21b80489e748414ef4cfb7aec49feecf06"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./lxc"

    generate_completions_from_executable(bin/"lxc", "completion")
  end

  test do
    output = JSON.parse(shell_output("#{bin}/lxc remote list --format json"))
    assert_equal "https://cloud-images.ubuntu.com/releases/", output["ubuntu"]["Addr"]

    assert_match version.to_s, shell_output("#{bin}/lxc --version")
  end
end
