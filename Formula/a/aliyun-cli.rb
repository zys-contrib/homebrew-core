class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.267",
      revision: "916aab28a7fabc925f99a921fb9e1e850ce0b6dc"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10a0ae492df05b62a0d8e8574912b5709456445ddac06b33bb7c14426666b6dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10a0ae492df05b62a0d8e8574912b5709456445ddac06b33bb7c14426666b6dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "10a0ae492df05b62a0d8e8574912b5709456445ddac06b33bb7c14426666b6dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "87fcb1b3bfbf988bff146db362d95c6b83a8055fb73f109f91229e9dc6ad5edc"
    sha256 cellar: :any_skip_relocation, ventura:       "87fcb1b3bfbf988bff146db362d95c6b83a8055fb73f109f91229e9dc6ad5edc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f3b226e93afcab0e82adb22184d956314a1d0eb0fb09868b7c7ea2a7ef3226c"
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
