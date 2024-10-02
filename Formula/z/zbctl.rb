class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-clients/cli-client/index/"
  url "https://github.com/camunda/zeebe/archive/refs/tags/8.5.8.tar.gz"
  sha256 "8fa156312da11867c9f4c61ddaa4ed333fda00ef31779d8fdaeeb6485fc339d6"
  license "Apache-2.0"
  head "https://github.com/camunda/zeebe.git", branch: "develop"

  # Upstream creates stable version tags (e.g., `v1.2.3`) before a release but
  # the version isn't considered to be released until a corresponding release
  # is created on GitHub. Upstream may not mark all unstable releases as
  # "pre-release", so we have to use the `GithubReleases` strategy until the
  # "latest" release is always a stable version.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0ce528be524cb905a333722acdcd4c077f539f9af6375900a4c03e2d0cf81db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0ce528be524cb905a333722acdcd4c077f539f9af6375900a4c03e2d0cf81db"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b0ce528be524cb905a333722acdcd4c077f539f9af6375900a4c03e2d0cf81db"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed3eda45d6557069b6dbda70c8a7a5d890b825a3606e1e32463731b85cc682df"
    sha256 cellar: :any_skip_relocation, ventura:       "ed3eda45d6557069b6dbda70c8a7a5d890b825a3606e1e32463731b85cc682df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98b792b0fa11185d9c90116ca085716a9815f5957891cd1e4731751bfe706d0e"
  end

  depends_on "go" => :build

  def install
    cd "clients/go/cmd/zbctl" do
      project = "github.com/camunda/zeebe/clients/go/v8/cmd/zbctl/internal/commands"
      ldflags = "-s -w -X #{project}.Version=#{version} -X #{project}.Commit=#{tap.user}"
      system "go", "build", "-tags", "netgo", *std_go_args(ldflags:)

      generate_completions_from_executable(bin/"zbctl", "completion")
    end
  end

  test do
    # Check status for a nonexistent cluster
    status_error_message =
      "Error: rpc error: code = " \
      "Unavailable desc = connection error: " \
      "desc = \"transport: Error while dialing: dial tcp 127.0.0.1:26500: connect: connection refused\""
    output = shell_output("#{bin}/zbctl status 2>&1", 1)
    assert_match status_error_message, output

    assert_match version.to_s, shell_output("#{bin}/zbctl version")
  end
end
