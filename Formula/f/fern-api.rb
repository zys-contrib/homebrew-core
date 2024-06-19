require "language/node"

class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.30.9.tgz"
  sha256 "37cef3493f314cd2d7728aff1648cfff5992065257010bb341e0180d76084ee8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "964cbd8145356a437b6e3f703b8a2dfa46447ed55573ffe105084adaddc2e330"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "964cbd8145356a437b6e3f703b8a2dfa46447ed55573ffe105084adaddc2e330"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "964cbd8145356a437b6e3f703b8a2dfa46447ed55573ffe105084adaddc2e330"
    sha256 cellar: :any_skip_relocation, sonoma:         "964cbd8145356a437b6e3f703b8a2dfa46447ed55573ffe105084adaddc2e330"
    sha256 cellar: :any_skip_relocation, ventura:        "964cbd8145356a437b6e3f703b8a2dfa46447ed55573ffe105084adaddc2e330"
    sha256 cellar: :any_skip_relocation, monterey:       "964cbd8145356a437b6e3f703b8a2dfa46447ed55573ffe105084adaddc2e330"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20df56958815c44ef03e9a04ff8ce717d6ceb5bab19f1d3ee537020705da6fb3"
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
