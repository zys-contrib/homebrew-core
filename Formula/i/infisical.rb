class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/infisical/archive/refs/tags/infisical-cli/v0.36.22.tar.gz"
  sha256 "1c9fa5162bbce661979740831d23a3cd08a25edfb85134c751e1946c448d5582"
  license "MIT"
  head "https://github.com/Infisical/infisical.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^infisical-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "990578e2c08b6826c8d580bdb1ab8620a0a11479b657d691f5a0447e13b1c0a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "990578e2c08b6826c8d580bdb1ab8620a0a11479b657d691f5a0447e13b1c0a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "990578e2c08b6826c8d580bdb1ab8620a0a11479b657d691f5a0447e13b1c0a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e9cbd92037524a2fa0576b0ccb883e209a8c4c92da68c60ab12a2b991d0eafc"
    sha256 cellar: :any_skip_relocation, ventura:       "5e9cbd92037524a2fa0576b0ccb883e209a8c4c92da68c60ab12a2b991d0eafc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74eb5476ab0aefb1bbe4da6079da33c0306c032d0ee9a4cfbfc8fd742f0f05f6"
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
