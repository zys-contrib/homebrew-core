class AwsConsole < Formula
  desc "Command-line to use AWS CLI credentials to launch the AWS console in a browser"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.20.1.tar.gz"
  sha256 "04cddedbe35074e66fa1683dacf9dc5cbb3913bcccaf9ba7a587936b2bce928b"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd63302480b83a477d2854d3c1218790cc05d845e23b94678a407b4623689d5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd63302480b83a477d2854d3c1218790cc05d845e23b94678a407b4623689d5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fd63302480b83a477d2854d3c1218790cc05d845e23b94678a407b4623689d5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d5f4e3ffdaa50d17cb0addd074967dc2b6323b34cad2c0214a44fd247d04bed"
    sha256 cellar: :any_skip_relocation, ventura:       "0d5f4e3ffdaa50d17cb0addd074967dc2b6323b34cad2c0214a44fd247d04bed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d553f976fc7b7942cd163c64f800b20bf07b067af424c65d29af404e5fdc0ab8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/aws-console"
  end

  test do
    # No other operation is possible without valid AWS credentials configured
    output = shell_output("#{bin}/aws-console 2>&1", 1)
    assert_match "a region was not specified. You can run 'aws configure' or choose a profile with a region", output
  end
end
