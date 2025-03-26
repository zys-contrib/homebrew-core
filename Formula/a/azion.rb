class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/2.7.0.tar.gz"
  sha256 "7a0aabce00f54b6bbc1f8f725f8b18d69c510e4d026d21d4fc1b8773584ad85e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "806a0bf7867d07a252cbcb9584bde52478df8920922f5175e63e7d3caff80712"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "806a0bf7867d07a252cbcb9584bde52478df8920922f5175e63e7d3caff80712"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "806a0bf7867d07a252cbcb9584bde52478df8920922f5175e63e7d3caff80712"
    sha256 cellar: :any_skip_relocation, sonoma:        "6af0cce835452143096b5b78eb29dcfe8188a5616311bc2d84015615919d078f"
    sha256 cellar: :any_skip_relocation, ventura:       "6af0cce835452143096b5b78eb29dcfe8188a5616311bc2d84015615919d078f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f61b2fe0ece3f20d3b1381d3a6d89eaac1805aa2b61d41ecbbeba740fd185e6d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/aziontech/azion-cli/pkg/cmd/version.BinVersion=#{version}
      -X github.com/aziontech/azion-cli/pkg/constants.StorageApiURL=https://api.azion.com
      -X github.com/aziontech/azion-cli/pkg/constants.AuthURL=https://sso.azion.com/api
      -X github.com/aziontech/azion-cli/pkg/constants.ApiURL=https://api.azionapi.net
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/azion"

    generate_completions_from_executable(bin/"azion", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azion --version")
    assert_match "Failed to build your resource", shell_output("#{bin}/azion build --yes 2>&1", 1)
  end
end
