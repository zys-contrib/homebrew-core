class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.151.1.tgz"
  sha256 "792f87c4fff343b78476af219007e007dff07dbd5fbe2ab7e41ae5052cb24bb0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "57ec3b5b05cca428d9e8f4e1077e9dc1a4c5ab29a03eb9df647c4a78c0f093d1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with native slices.
    deuniversalize_machos
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
