class Doppler < Formula
  desc "CLI for interacting with Doppler secrets and configuration"
  homepage "https://docs.doppler.com/docs"
  url "https://github.com/DopplerHQ/cli/archive/refs/tags/3.73.2.tar.gz"
  sha256 "1f59b0facd39905b831dd5275ffb508d5dfab5a6ecb74bb6ba54c68b8d47f7b7"
  license "Apache-2.0"
  head "https://github.com/DopplerHQ/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa429b58dad8b4b96d916f40eff5f5596db4a9fc2cfa71d14287818d323753b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa429b58dad8b4b96d916f40eff5f5596db4a9fc2cfa71d14287818d323753b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fa429b58dad8b4b96d916f40eff5f5596db4a9fc2cfa71d14287818d323753b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f546fb9c42fb6c4a926c16ddf88d23855004e58b3e86f7ca890b898eab8b54b"
    sha256 cellar: :any_skip_relocation, ventura:       "3f546fb9c42fb6c4a926c16ddf88d23855004e58b3e86f7ca890b898eab8b54b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "478d09d000a34f5e78eefdec1744dea5c46716082e91a5f79c5462c91d0bc6a3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/DopplerHQ/cli/pkg/version.ProgramVersion=dev-#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"doppler", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/doppler --version")

    output = shell_output("#{bin}/doppler setup 2>&1", 1)
    assert_match "Doppler Error: you must provide a token", output
  end
end
