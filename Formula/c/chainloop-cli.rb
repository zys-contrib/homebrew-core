class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.91.7.tar.gz"
  sha256 "ad5635a4b169aedfebade3679b9a9aa527bdf435f509c4b2d98995ffb0543ac6"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5c3bf207cedddb5ea4d2b9981b149be465cf72b419360912a462c640e31bfeda"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f73338bfe30923762a7e1060200ff9ee939654db5f560d4d628858b2d726a85"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aae1c4c389ab1061dba998eea3e935d88913b23135884ce5e0951f0e0bd5b576"
    sha256 cellar: :any_skip_relocation, sonoma:         "5480265df30c7ec7eeb4d3ce2acfd0c1d42621dee23d52a702b70ba518e3d0a2"
    sha256 cellar: :any_skip_relocation, ventura:        "901ac4d899e2d34194c5e4068a29dff2e42dc7d15fb1dff9aadabc8c24ba9373"
    sha256 cellar: :any_skip_relocation, monterey:       "87b6aa669abaa1ce1e702061eb330f3e3308ce66ec4ed84ee20f65f70f4d3934"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a842cf0b9e46a656ccb9c38ef518d7006de883a4f5b32fb6618dc128eee0c0e"
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
