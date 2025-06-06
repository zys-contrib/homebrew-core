class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/infisical/archive/refs/tags/infisical-cli/v0.41.82.tar.gz"
  sha256 "ff53a31339fdb01044a31b0abb62649935c40762c4ac07cbc5807900b2bf8811"
  license "MIT"
  head "https://github.com/Infisical/infisical.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^infisical-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "361d9c188aa0aeced55be61c1970b97364c6bbc260802d3ee55f35063c67453c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "361d9c188aa0aeced55be61c1970b97364c6bbc260802d3ee55f35063c67453c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "361d9c188aa0aeced55be61c1970b97364c6bbc260802d3ee55f35063c67453c"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc250448429b7cffa09ccb553e5bc5e07417aa844338f5fb8206ed4f9558f883"
    sha256 cellar: :any_skip_relocation, ventura:       "bc250448429b7cffa09ccb553e5bc5e07417aa844338f5fb8206ed4f9558f883"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a4890412b785d5b71d8f1d1af801fcfb87b124f863b42e85a233a9b6f728d22"
  end

  depends_on "go" => :build

  def install
    cd "cli" do
      ldflags = %W[
        -s -w
        -X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}
      ]
      system "go", "build", *std_go_args(ldflags:)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical agent 2>&1")
    assert_match "starting Infisical agent", output
  end
end
