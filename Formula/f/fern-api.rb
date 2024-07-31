class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.36.0.tgz"
  sha256 "63c6c4fa76098b2f158e1b57d14c61b51b6d532270bc918dae0e25c0713c2496"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "13a9c7627e3e626a4d504e634e61e777f3ca5864f2ce2973b7698e61c415206a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13a9c7627e3e626a4d504e634e61e777f3ca5864f2ce2973b7698e61c415206a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13a9c7627e3e626a4d504e634e61e777f3ca5864f2ce2973b7698e61c415206a"
    sha256 cellar: :any_skip_relocation, sonoma:         "13a9c7627e3e626a4d504e634e61e777f3ca5864f2ce2973b7698e61c415206a"
    sha256 cellar: :any_skip_relocation, ventura:        "13a9c7627e3e626a4d504e634e61e777f3ca5864f2ce2973b7698e61c415206a"
    sha256 cellar: :any_skip_relocation, monterey:       "13a9c7627e3e626a4d504e634e61e777f3ca5864f2ce2973b7698e61c415206a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ff30e3ec65a1895838a92c590d0ed46d4b6d4cdf08f7392248056c420ecbda9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/fern init 2>&1", 1)
    assert_match "Login required", output

    assert_match version.to_s, shell_output("#{bin}/fern --version")
  end
end
