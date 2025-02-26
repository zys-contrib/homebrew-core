class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1001.0.tgz"
  sha256 "5fb5a41e9d4eb5c5ef2f8e4b93d961460407e664bf0ff6c2d857910d22fbf783"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "795f74a010600f52379f14a2536050ba08b4bbb74ad8b11d7d57209a41d43d51"
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
