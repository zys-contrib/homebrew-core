class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/infisical/archive/refs/tags/infisical-cli/v0.36.11.tar.gz"
  sha256 "fac23179c60191f57f8a79de8047c31f06c723fbff9a3439f09bd7b86abb7275"
  license "MIT"
  head "https://github.com/Infisical/infisical.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^infisical-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "119b2a3cdb85af858270cdaa88d96ef0624484055c1517febaed490211be09d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "119b2a3cdb85af858270cdaa88d96ef0624484055c1517febaed490211be09d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "119b2a3cdb85af858270cdaa88d96ef0624484055c1517febaed490211be09d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "6596b16691e4f9296a8eca5642af4a1e10b62735ac16d87c239e6b489092bd19"
    sha256 cellar: :any_skip_relocation, ventura:       "6596b16691e4f9296a8eca5642af4a1e10b62735ac16d87c239e6b489092bd19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "054db4879fe510f789911d5c8ea617e461818043101e8433200f4839093ec2cd"
  end

  depends_on "go"

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

    output = shell_output("#{bin}/infisical init 2>&1", 1)
    assert_match "You must be logged in to run this command.", output
  end
end
