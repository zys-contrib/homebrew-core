class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.179.0.tgz"
  sha256 "3de8987a88de4a71b8d51583f27fcb2ac0fcbec6af31045aa2657de06484e22b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d85a9120d4379e7f34e4e3559ef59aa8225509ec53e31af2b834817efe96f84e"
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
