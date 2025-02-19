class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1000.2.tgz"
  sha256 "724cb6b60eac258e2fe6bdd872d56c7573c3185fbf9af74d6d321494f2b0a934"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f97ffbe0cc3432d2bf135e223efb7bf1232df6c738485163fc46dd54962ba7c1"
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
