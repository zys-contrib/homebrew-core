class CfnFormat < Formula
  desc "Command-line tool for formatting AWS CloudFormation templates"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "820724a0cde1066345982b81b42921af86906966d0e51151ed24a6e3c1f08740"
  license "Apache-2.0"
  head "https://github.com/aws-cloudformation/rain.git", branch: "main"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72e9c30daf8e805fb601f35bd69f800e6dc3ef025f5d358879fd286a4ed88feb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72e9c30daf8e805fb601f35bd69f800e6dc3ef025f5d358879fd286a4ed88feb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "72e9c30daf8e805fb601f35bd69f800e6dc3ef025f5d358879fd286a4ed88feb"
    sha256 cellar: :any_skip_relocation, sonoma:        "21a37d9b9238f791b3227f011e38196bd27b5be322161d2f15dc988be430bb18"
    sha256 cellar: :any_skip_relocation, ventura:       "21a37d9b9238f791b3227f011e38196bd27b5be322161d2f15dc988be430bb18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e654332c504dd68be733cd9e528a15c19f79131e674cd949eff02c3b36cdf36"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cfn-format"
  end

  test do
    (testpath/"test.template").write <<~YAML
      Resources:
        Bucket:
          Type: AWS::S3::Bucket
    YAML
    assert_equal "test.template: formatted OK", shell_output("#{bin}/cfn-format -v test.template").strip
  end
end
