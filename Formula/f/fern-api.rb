require "language/node"

class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.30.10.tgz"
  sha256 "f609376b7c29becbc5e1b6f3eecc6ebf65d69aaa012bc33ce43c7ba3cc40865b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1b3862ce10196080f620239afaca179fa8314d00640770e2838143eb105d5332"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b3862ce10196080f620239afaca179fa8314d00640770e2838143eb105d5332"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b3862ce10196080f620239afaca179fa8314d00640770e2838143eb105d5332"
    sha256 cellar: :any_skip_relocation, sonoma:         "1b3862ce10196080f620239afaca179fa8314d00640770e2838143eb105d5332"
    sha256 cellar: :any_skip_relocation, ventura:        "1b3862ce10196080f620239afaca179fa8314d00640770e2838143eb105d5332"
    sha256 cellar: :any_skip_relocation, monterey:       "1b3862ce10196080f620239afaca179fa8314d00640770e2838143eb105d5332"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd5022058cb942723a75ae177602ae1f3b53a7e03bff38dc17ac7a3ff4574928"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/fern init 2>&1", 1)
    assert_match "Login required", output

    assert_match version.to_s, shell_output("#{bin}/fern --version")
  end
end
