class Frizbee < Formula
  desc "Throw a tag at and it comes back with a checksum"
  homepage "https://github.com/stacklok/frizbee"
  url "https://github.com/stacklok/frizbee/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "f3e7e5b111588347b968179c03de94bfe1b1137696fc3d01987868ac5f08bc97"
  license "Apache-2.0"
  head "https://github.com/stacklok/frizbee.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93f8f8aec9503ec9c4036b98ae3c7d356cabee8f2ceca7e761e66b8ef8a8f6d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93f8f8aec9503ec9c4036b98ae3c7d356cabee8f2ceca7e761e66b8ef8a8f6d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "93f8f8aec9503ec9c4036b98ae3c7d356cabee8f2ceca7e761e66b8ef8a8f6d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b1dbf210e7de8bc465f9c17444e69b2b56d5fb3951380bdf5a6581fdb8c298d"
    sha256 cellar: :any_skip_relocation, ventura:       "8b1dbf210e7de8bc465f9c17444e69b2b56d5fb3951380bdf5a6581fdb8c298d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c4a6195d5c89e7a65119251e52459c2ef93184e2b6ff60145c1544bcb520456"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/stacklok/frizbee/internal/cli.CLIVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"frizbee", "completion")
  end

  test do
    assert_match version.to_s, shell_output(bin/"frizbee version 2>&1")

    output = shell_output(bin/"frizbee actions $(brew --repository)/.github/workflows/tests.yml 2>&1")
    assert_match "Processed: tests.yml", output
  end
end
