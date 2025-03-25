class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1006.0.tgz"
  sha256 "e0fb8dc393e27bb1df85c0d95a95b6367b3362824ff1030b55c0fdccef73734a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "40d45588f36a823d798285c2c78f78b3de6fad39bf974749826b9f98f82f539f"
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
