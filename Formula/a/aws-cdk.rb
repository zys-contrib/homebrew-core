class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1017.0.tgz"
  sha256 "095f4452d6becff5a1d86cae902e5b27e1c093548e03cbb69c71588cfa174219"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cfb0f03903473921b7d4d561784e6046eeaaaeaaf6bdcb22ca1b5f347fcdabc1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    # `cdk init` cannot be run in a non-empty directory
    mkdir "testapp" do
      shell_output("#{bin}/cdk init app --language=javascript")
      list = shell_output("#{bin}/cdk list")
      cdkversion = shell_output("#{bin}/cdk --version")
      assert_match "TestappStack", list
      assert_match version.to_s, cdkversion
    end
  end
end
