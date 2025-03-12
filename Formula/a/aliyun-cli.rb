class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.259",
      revision: "942b24e7571565f9d349e6446761d0a57fa04c7d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e4a0ac74f590b5291d63d21c55ce2e6522db037b18a7f1b2c0be8738d1fb2e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e4a0ac74f590b5291d63d21c55ce2e6522db037b18a7f1b2c0be8738d1fb2e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5e4a0ac74f590b5291d63d21c55ce2e6522db037b18a7f1b2c0be8738d1fb2e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "30a9857e0977b1211cef411b931b41fc1db8b7c6f0357728e2470d329d5cb877"
    sha256 cellar: :any_skip_relocation, ventura:       "30a9857e0977b1211cef411b931b41fc1db8b7c6f0357728e2470d329d5cb877"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a74bc63eb3d0ad433019e8d91c324e01325269f337f32359f144bb9348d54a5c"
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
