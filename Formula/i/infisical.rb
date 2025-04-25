class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/infisical/archive/refs/tags/infisical-cli/v0.40.1.tar.gz"
  sha256 "4fbe5ca0c726ef96d14031d9ebf06e1b7c0a76e07eb37ebab8d92c1ff8cc4b5c"
  license "MIT"
  head "https://github.com/Infisical/infisical.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^infisical-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39b94fc973cfa2e627af7667ae9ed1e55fcd6d1defcc21a708b87a56e9097102"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39b94fc973cfa2e627af7667ae9ed1e55fcd6d1defcc21a708b87a56e9097102"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "39b94fc973cfa2e627af7667ae9ed1e55fcd6d1defcc21a708b87a56e9097102"
    sha256 cellar: :any_skip_relocation, sonoma:        "462fb8b47b2d0e0b982d55cd4c2e9e0415db9ffa0a42efa38c29b1a708cf7726"
    sha256 cellar: :any_skip_relocation, ventura:       "462fb8b47b2d0e0b982d55cd4c2e9e0415db9ffa0a42efa38c29b1a708cf7726"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3dc2c8c9460f48184a20f8d89f7c7ec2d8f20f4d7885a16f8243d590c49dd82"
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

    output = shell_output("#{bin}/infisical init 2>&1", 1)
    assert_match "You must be logged in to run this command.", output
  end
end
