class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1013.0.tgz"
  sha256 "7884ce13d21094736d573b51f64ac673a4d385e9be5e272431f0628af5e43c31"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c4fd8a7e235b8d8a16190f2e77155c1616abea9df8c2f96dcf7bf6fad8724820"
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
