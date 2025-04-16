class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1008.0.tgz"
  sha256 "5f4e6d329565ec5071f163073e7b120940254a312483a5364722c5a73f3c2264"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f2b32773daa62fb40be7db8ab1be2bf5a0a4b04ee77eb79ee6708ede863039ec"
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
