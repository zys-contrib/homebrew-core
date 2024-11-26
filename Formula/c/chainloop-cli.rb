class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.131.0.tar.gz"
  sha256 "65449aaf75b4be62eb7fe60423e0f1f8095ab84a823726590cf796f9e90b65da"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d763ceeace4109e6f7fa24e0766b3ecad9ca6ccf8909662662373eceae607213"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d763ceeace4109e6f7fa24e0766b3ecad9ca6ccf8909662662373eceae607213"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d763ceeace4109e6f7fa24e0766b3ecad9ca6ccf8909662662373eceae607213"
    sha256 cellar: :any_skip_relocation, sonoma:        "189190959a0d87092740da812b5e26254e9afbaf262a72975688e77e65824ca1"
    sha256 cellar: :any_skip_relocation, ventura:       "419f15686117b2ddcac9f1733dd85ea63805d9391210da8864f2a2f6678eee39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50e8d1e8a6cc63d6e5d078a50a39fcdfa6e804a7e1eeaff288f63d9ad891d30a"
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
