class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.257",
      revision: "9de2250b24a23dcdb4b732cca8dec0a7dd502038"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de5efe9be7e968e88f1f0af8f7d28d489e3e53c8f35b19185233e5b07875f78b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de5efe9be7e968e88f1f0af8f7d28d489e3e53c8f35b19185233e5b07875f78b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "de5efe9be7e968e88f1f0af8f7d28d489e3e53c8f35b19185233e5b07875f78b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a89841343b9ea8c0cb8deba834d3b2237e353b012ceeaf54b16712a9e2897c37"
    sha256 cellar: :any_skip_relocation, ventura:       "a89841343b9ea8c0cb8deba834d3b2237e353b012ceeaf54b16712a9e2897c37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b71bf21fc99ca4ccb3598a8fa13e85e196e485383a9743b5d7e70912a27cff1a"
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
