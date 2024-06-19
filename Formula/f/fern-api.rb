require "language/node"

class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.30.8.tgz"
  sha256 "9faab2ed3df61775d84374c96e8736a84e1bf055f3ebe4863a681e79d2f33eac"
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
