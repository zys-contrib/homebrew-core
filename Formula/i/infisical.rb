class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/infisical/archive/refs/tags/infisical-cli/v0.41.88.tar.gz"
  sha256 "04b7dc2edf86cf6e917229f6d390bc4af08fc4ed39b87f434a578a973434ae19"
  license "MIT"
  head "https://github.com/Infisical/infisical.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^infisical-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90ecc5d68939495bf40951cdb53a166fd9687aae552cb714d4a9779de4eb3774"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90ecc5d68939495bf40951cdb53a166fd9687aae552cb714d4a9779de4eb3774"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "90ecc5d68939495bf40951cdb53a166fd9687aae552cb714d4a9779de4eb3774"
    sha256 cellar: :any_skip_relocation, sonoma:        "64b339a9b661227e50074d0175259b1a6ba47ef410c17fe64e9b57cdaf68353d"
    sha256 cellar: :any_skip_relocation, ventura:       "64b339a9b661227e50074d0175259b1a6ba47ef410c17fe64e9b57cdaf68353d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7f03bde2b4a3834f0d2db9a49dba3e2d6600d884595b4dd11a0ad1ab2af58c3"
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
