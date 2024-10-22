class AwsConsole < Formula
  desc "Command-line to use AWS CLI credentials to launch the AWS console in a browser"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "8c43c6079081184d6526bb1901d9731ecbb1db20089dd689aa816bffba931d7d"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "685d46bcdfc69e12779450040fcdf3969768a435be2631d63e79d2a5bfb9b57a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "685d46bcdfc69e12779450040fcdf3969768a435be2631d63e79d2a5bfb9b57a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "685d46bcdfc69e12779450040fcdf3969768a435be2631d63e79d2a5bfb9b57a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7928bfd62f08fb5e1342041ef3890bf76d02c8be9a8ff0868edf67f5e7320ad"
    sha256 cellar: :any_skip_relocation, ventura:       "e7928bfd62f08fb5e1342041ef3890bf76d02c8be9a8ff0868edf67f5e7320ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5c254376abdf61e848bfdd3bdef11b65fc27606eb7854eeb444e6609088702a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "cmd/aws-console/main.go"
  end

  test do
    # No other operation is possible without valid AWS credentials configured
    output = shell_output("#{bin}/aws-console 2>&1", 1)
    assert_match "a region was not specified. You can run 'aws configure' or choose a profile with a region", output
  end
end
