class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/infisical/archive/refs/tags/infisical-cli/v0.37.0.tar.gz"
  sha256 "9ac9c8fe27b4f95153706ee22c9a82bdcdd5095c106a0e57ea7dab2de0795ae3"
  license "MIT"
  head "https://github.com/Infisical/infisical.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^infisical-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf47b365726d7e5eff7c8ce8510b708d4f0297fce287b82fd77648533abf36e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf47b365726d7e5eff7c8ce8510b708d4f0297fce287b82fd77648533abf36e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf47b365726d7e5eff7c8ce8510b708d4f0297fce287b82fd77648533abf36e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba5f0886a08926d2214200355b360b5a2214432c31df7fb17af2c42e9d8b6f92"
    sha256 cellar: :any_skip_relocation, ventura:       "ba5f0886a08926d2214200355b360b5a2214432c31df7fb17af2c42e9d8b6f92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95aab6537f6bf31e076c2671467fd834451a876ea0cd9388937814ecb2caee9e"
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
