class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.142.0.tar.gz"
  sha256 "4b81f914bcc19b0dc774519bc29fb9158a5cdb3fdd57769ef7c93d6f5f0ab914"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1eaa1d7a65fe9e826b041e1b3e580032728f91618df9589805fa6c9b448f53e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1eaa1d7a65fe9e826b041e1b3e580032728f91618df9589805fa6c9b448f53e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1eaa1d7a65fe9e826b041e1b3e580032728f91618df9589805fa6c9b448f53e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b6c61e5b21d61db3d7efb6369a37cddea5d5b1f83300f4ed8a0dc414ffe37e2"
    sha256 cellar: :any_skip_relocation, ventura:       "7ef2ea3139a96024cf01100806f9f22002458f7b6cfbbb5d08eb2c3cc9c23e9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "970bd36eb2b1cc7cba81494192af5d1e94061376c5db0fd71ea936e722b5dad1"
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
