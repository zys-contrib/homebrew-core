class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1017.1.tgz"
  sha256 "2a10b74b689a7eff92195a162da6a46c4ed454524340da773dc488dfae9242d5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9b01579c1c92b5ff9b44bdedb2c03d05602746ff4b8bf7b201f0b2cce626c5e1"
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
