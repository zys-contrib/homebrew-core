class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.173.3.tgz"
  sha256 "198af43c577dcfd4e89b47baa716a029b91cd7942b30cd5e6622a9dace4dacdc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4ecbd6707f866b6afe898628f701ad4918ac3cc2edcaba33614c77e14490b276"
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
