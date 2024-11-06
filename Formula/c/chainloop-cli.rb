class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.100.0.tar.gz"
  sha256 "c7c65178e0ecb7613754607e5afa10a06129fe18ae80a432ba36164ad1acddd0"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9eba3dbd9b78eb49ae173dd38539c984502113da402744655ac92dc17e6cc306"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9eba3dbd9b78eb49ae173dd38539c984502113da402744655ac92dc17e6cc306"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9eba3dbd9b78eb49ae173dd38539c984502113da402744655ac92dc17e6cc306"
    sha256 cellar: :any_skip_relocation, sonoma:        "27dc03365113d2f01f8e593ac4d47e6e781164835d11872c1646edba9b9132f9"
    sha256 cellar: :any_skip_relocation, ventura:       "73f54c27100a622e6458008d532c8b144cb1362591fbc0445b4446d2b446592c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3008dd09f044c0d38a52fe7932a87de6235846aac6161b38303f685bfc9ad25b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", "completion", base_name: "chainloop")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end
