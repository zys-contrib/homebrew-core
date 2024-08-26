class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.220",
      revision: "76653bcc49808c8abbcb7e46f116144b5d459d3a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f4cabba8df993e21f60c751a7882b7ae2ea2a1912e365bd4418a2517c4f7a5ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4cabba8df993e21f60c751a7882b7ae2ea2a1912e365bd4418a2517c4f7a5ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4cabba8df993e21f60c751a7882b7ae2ea2a1912e365bd4418a2517c4f7a5ab"
    sha256 cellar: :any_skip_relocation, sonoma:         "55af41bf5c0704c4bf431ff648da4f41369ec7a0727b09a53916dc5fb0a9ad5b"
    sha256 cellar: :any_skip_relocation, ventura:        "55af41bf5c0704c4bf431ff648da4f41369ec7a0727b09a53916dc5fb0a9ad5b"
    sha256 cellar: :any_skip_relocation, monterey:       "55af41bf5c0704c4bf431ff648da4f41369ec7a0727b09a53916dc5fb0a9ad5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86ccc19cc40a1adc73689bf3e3914201bef1658251f3f219d2d93c63d723aae9"
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
