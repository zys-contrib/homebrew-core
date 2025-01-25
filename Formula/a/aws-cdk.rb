class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.177.0.tgz"
  sha256 "dbdd27cd98a53bc0ec1ebd89cd6db53a5df1ce90643c3706ecc5ef08edf44d04"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8665e6e9c545f1497db84eccfe59daf46afa51085d6f4d3ba5a4d46ca0bea495"
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
