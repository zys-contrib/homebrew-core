class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.153.0.tgz"
  sha256 "64e4bf8e8b5737b62962a44d969178ea4826f44f229c4af346258cdc0f0843e2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7b44567bfe1ff62d9170322cd61a5569049d7f05f3fb1f0b598ac5fd3659c749"
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
