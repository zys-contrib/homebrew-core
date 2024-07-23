require "language/node"

class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.33.4.tgz"
  sha256 "f57b9fdc2c0d7f1bebc65fcf82c1fe3adcd9bb51781881cfe5f4d98c88c26b03"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "89cf266b7f707104eecc8e11ad8d9f5586d997596a8dba16ab70366af39f5e16"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89cf266b7f707104eecc8e11ad8d9f5586d997596a8dba16ab70366af39f5e16"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89cf266b7f707104eecc8e11ad8d9f5586d997596a8dba16ab70366af39f5e16"
    sha256 cellar: :any_skip_relocation, sonoma:         "89cf266b7f707104eecc8e11ad8d9f5586d997596a8dba16ab70366af39f5e16"
    sha256 cellar: :any_skip_relocation, ventura:        "89cf266b7f707104eecc8e11ad8d9f5586d997596a8dba16ab70366af39f5e16"
    sha256 cellar: :any_skip_relocation, monterey:       "89cf266b7f707104eecc8e11ad8d9f5586d997596a8dba16ab70366af39f5e16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9373be18afadeb996288432fc6dc1c2d998d56a5d9c7617e464aef5f2ff937cf"
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
