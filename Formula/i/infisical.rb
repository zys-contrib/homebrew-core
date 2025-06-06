class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/infisical/archive/refs/tags/infisical-cli/v0.41.8.tar.gz"
  sha256 "37a498160e5086bba645059296e28990a780ac848988d0b78d3e2546583f6040"
  license "MIT"
  head "https://github.com/Infisical/infisical.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^infisical-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b033879c5a4e63e5ad13d39d0d64b1e2fa62d2ee56e19d0dfe7f6d48fec4275"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b033879c5a4e63e5ad13d39d0d64b1e2fa62d2ee56e19d0dfe7f6d48fec4275"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b033879c5a4e63e5ad13d39d0d64b1e2fa62d2ee56e19d0dfe7f6d48fec4275"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad15e11120548df2b5fdd0a312562e462d144e80e38042ed7e015b18c2eb0c7a"
    sha256 cellar: :any_skip_relocation, ventura:       "ad15e11120548df2b5fdd0a312562e462d144e80e38042ed7e015b18c2eb0c7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b32a8aa3a33235b8ac1c49f306a37d70371ccff8a45353c9ebb995647e9eacf6"
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
