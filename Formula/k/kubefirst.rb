class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.io/"
  url "https://github.com/konstructio/kubefirst/archive/refs/tags/v2.5.3.tar.gz"
  sha256 "dfb956f5516bc7d08d26eef4e7e5a3a4052bb317671c21195467441147ae70fb"
  license "MIT"
  head "https://github.com/konstructio/kubefirst.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released, so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "39f1abd48331c6fe3a3dbb9b83288d226daf99a1f9cbaa21270c8b1ea1f74b09"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07773eb34cee97c00f6f34ca0a78912154156702afda336286761ee7df68dae3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c5ae4b2cc65f92b921387a8f06b75804f1f5276dfa1fb6f8b544a4b5f7ffa09"
    sha256 cellar: :any_skip_relocation, sonoma:         "fbd9879b98123331ef720bf4cdb9ec3d0bdafd84378cbe367dbe28c635ec5682"
    sha256 cellar: :any_skip_relocation, ventura:        "c522ac8a6737c6b787c10d698cd669efa14c1774b9d345c39ec7934b17c54ebc"
    sha256 cellar: :any_skip_relocation, monterey:       "8b56cf9bd80b44849ceadd1e4b909f2c0ec70b9952274eaf60be4800d5b95f64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fbb74f67890e2d85491578ac82a96a58578427dbcc44fb7d9e773127f3f5ea8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/konstructio/kubefirst-api/configs.K1Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    system bin/"kubefirst", "info"
    assert_match "k1-paths:", (testpath/".kubefirst").read
    assert_predicate testpath/".k1/logs", :exist?

    output = shell_output("#{bin}/kubefirst version")
    expected = if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      ""
    else
      version.to_s
    end
    assert_match expected, output
  end
end
