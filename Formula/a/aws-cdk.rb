class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.178.0.tgz"
  sha256 "69130675f2b65629495bf0874c209786792ca5806d84021692ee6ce1fc1cdec9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ae57ff00d7312929496cd694d2468e7026a5c8797ead5cc32edb3b914a8bba0e"
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
