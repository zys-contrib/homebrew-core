class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.173.2.tgz"
  sha256 "c35c882d838b06a059047589a9d0a1b2f08db1dc9d44b4a1e7cb7985bcc7a2aa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "04cb25d0c7c2336668bb8112677135d4ac308d72f51ceae2303f3063dbb96889"
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
