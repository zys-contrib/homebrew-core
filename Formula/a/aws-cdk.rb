class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1016.0.tgz"
  sha256 "1eede4b6872b4891c169511ab65777f2253ce9f62e63d63ce8e4558c5c25a7ec"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d4e1ca9f2be81f08be86412791251d12b0b0492cfb3338a2ca61924baefb49e7"
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
