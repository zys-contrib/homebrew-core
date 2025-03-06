class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/infisical/archive/refs/tags/infisical-cli/v0.36.9.tar.gz"
  sha256 "80a7429b300555e7bdc6ed3c589b093b2251d264045b4060dc4c95c0798a89af"
  license "MIT"
  head "https://github.com/Infisical/infisical.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^infisical-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e946c836833e0f94a9317ced236d11a9d03c498c313f908684b0fcf81b4f1ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e946c836833e0f94a9317ced236d11a9d03c498c313f908684b0fcf81b4f1ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8e946c836833e0f94a9317ced236d11a9d03c498c313f908684b0fcf81b4f1ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "f16bbb65e74585b48ecf7b150a5fedab9683b1fb6b183ac014d097b8e25eff24"
    sha256 cellar: :any_skip_relocation, ventura:       "f16bbb65e74585b48ecf7b150a5fedab9683b1fb6b183ac014d097b8e25eff24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5376869637d0149307dc7396c12646e849ffb8d174ce21a21f0c1efb37c3c4b"
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
