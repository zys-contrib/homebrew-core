class Firefly < Formula
  desc "Create and manage the Hyperledger FireFly stack for blockchain interaction"
  homepage "https://hyperledger.github.io/firefly/latest/"
  url "https://github.com/hyperledger/firefly-cli/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "d2b0420b37c1ce6195e0739b2341502e65fea23c3ddd41cd55159ea237e01f23"
  license "Apache-2.0"
  head "https://github.com/hyperledger/firefly-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/hyperledger/firefly-cli/cmd.BuildDate=#{Time.now.utc.iso8601}
      -X github.com/hyperledger/firefly-cli/cmd.BuildCommit=#{tap.user}
      -X github.com/hyperledger/firefly-cli/cmd.BuildVersionOverride=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "ff/main.go"

    generate_completions_from_executable(bin/"firefly", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/firefly version --short")
    assert_match "Error: an error occurred while running docker", shell_output("#{bin}/firefly start mock 2>&1", 1)
  end
end
