class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/infisical/archive/refs/tags/infisical-cli/v0.35.0.tar.gz"
  sha256 "30eed6dff3a9f5d220d931d5264e84b26de8d8e6a8fe12527bd41bc2425cef19"
  license "MIT"
  head "https://github.com/Infisical/infisical.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^infisical-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a67692400259c89ef72d66305ad2044f9507b978f095975a05c43145bbe07d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a67692400259c89ef72d66305ad2044f9507b978f095975a05c43145bbe07d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2a67692400259c89ef72d66305ad2044f9507b978f095975a05c43145bbe07d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab5abe9f7cd7916d21354f15850d6aa9ba9f21f8e204fc71f021cf2637125d42"
    sha256 cellar: :any_skip_relocation, ventura:       "ab5abe9f7cd7916d21354f15850d6aa9ba9f21f8e204fc71f021cf2637125d42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de44651ba00eece2b22d78900a5165c1cf86d87d1de48cac459980ea1b156123"
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
