class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.274",
      revision: "0349962a04f1ca936152be5f31b015d739e859d0"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba9cdbe97d2e7ff6eb0dd152fb21da4076a7dfa22f2f9dfc4c538dee5a63dc8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba9cdbe97d2e7ff6eb0dd152fb21da4076a7dfa22f2f9dfc4c538dee5a63dc8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ba9cdbe97d2e7ff6eb0dd152fb21da4076a7dfa22f2f9dfc4c538dee5a63dc8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "abc555ddd57b87be8f8a7f5a47e8f67988ae1ff97e734742f1b0fef2ac821e29"
    sha256 cellar: :any_skip_relocation, ventura:       "abc555ddd57b87be8f8a7f5a47e8f67988ae1ff97e734742f1b0fef2ac821e29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb97b8a852d66e81483d325674e3d757854961deeee4763ece4e2cda7239c58b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/aliyun/aliyun-cli/v#{version.major}/cli.Version=#{version}"
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
