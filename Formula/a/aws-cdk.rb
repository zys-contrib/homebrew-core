class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1010.0.tgz"
  sha256 "da888e141007490e6588e11feb8ab574c70c3eea79a35212a2a3e942e73fa6da"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b32ead97c47f6e76933443d8487a08bb86cee502fd1d615a6e44ddaba31283a3"
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
