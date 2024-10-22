class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.163.0.tgz"
  sha256 "b0060aa0d7e6cfc298a75977637de9d3399a4ba994a7baff995c4ddab9c0e0b4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2a0318549062e83b2c4fa3dc490ecf3198b4084ce4b28f0c1cb5bde1dde03717"
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
