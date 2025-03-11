class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/refs/tags/v7.9.4.tar.gz"
  sha256 "5d8d449e57aff589e3386ae2ce9e640b357425cba9214a549b9bc428b2d32194"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4628193bc6444af1905d6415ae44e212303fc1285d207d8bea9baed0551386de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4628193bc6444af1905d6415ae44e212303fc1285d207d8bea9baed0551386de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4628193bc6444af1905d6415ae44e212303fc1285d207d8bea9baed0551386de"
    sha256 cellar: :any_skip_relocation, sonoma:        "53774c3322fa45478842a8614ca4f0004a0685dead6a396970951bd2baa99652"
    sha256 cellar: :any_skip_relocation, ventura:       "53774c3322fa45478842a8614ca4f0004a0685dead6a396970951bd2baa99652"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "770d70ca708ab7bce0ee6cdc497ae74026f7e82f6b518981b4569e197aaa8240"
  end

  depends_on "go" => :build

  def install
    # https://github.com/cloudfoundry/bosh-cli/blob/master/ci/tasks/build.sh#L23-L24
    inreplace "cmd/version.go", "[DEV BUILD]", "#{version}-#{tap.user}-#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"bosh-cli", "generate-job", "brew-test"
    assert_path_exists testpath/"jobs/brew-test"

    assert_match version.to_s, shell_output("#{bin}/bosh-cli --version")
  end
end
