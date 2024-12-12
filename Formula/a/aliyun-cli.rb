class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.237",
      revision: "c89dbf006ffdba5b752a3169eee338b8b06a78cd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e006b30f7d875fc43c85b5e6ef1bb87650d45fb3d0192c9dc630e27efa880a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e006b30f7d875fc43c85b5e6ef1bb87650d45fb3d0192c9dc630e27efa880a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4e006b30f7d875fc43c85b5e6ef1bb87650d45fb3d0192c9dc630e27efa880a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc920a9d6b33e9a037cea1ac365abb0d4b182257ee949ed60379c560201b221f"
    sha256 cellar: :any_skip_relocation, ventura:       "bc920a9d6b33e9a037cea1ac365abb0d4b182257ee949ed60379c560201b221f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b67dbf6fb229da6262d560606ff53379437b96ea5b6fc1a97014c7d754d6b3e4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/aliyun/aliyun-cli/cli.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"aliyun", ldflags:), "main/main.go"
  end

  test do
    version_out = shell_output("#{bin}/aliyun version")
    assert_match version.to_s, version_out

    help_out = shell_output("#{bin}/aliyun --help")
    assert_match "Alibaba Cloud Command Line Interface Version #{version}", help_out
    assert_match "", help_out
    assert_match "Usage:", help_out
    assert_match "aliyun <product> <operation> [--parameter1 value1 --parameter2 value2 ...]", help_out

    oss_out = shell_output("#{bin}/aliyun oss")
    assert_match "Object Storage Service", oss_out
    assert_match "aliyun oss [command] [args...] [options...]", oss_out
  end
end
