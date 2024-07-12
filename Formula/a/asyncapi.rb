require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-2.0.4.tgz"
  sha256 "e495220391ead38aff292f5fb819dff67e81452d2ecc5f1aaee33e9bc4cab837"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ed8d6745b33ca1c910329c7a06c56e7e27fae2177abc3b010a87492fa2f53467"
    sha256 cellar: :any,                 arm64_ventura:  "ed8d6745b33ca1c910329c7a06c56e7e27fae2177abc3b010a87492fa2f53467"
    sha256 cellar: :any,                 arm64_monterey: "ed8d6745b33ca1c910329c7a06c56e7e27fae2177abc3b010a87492fa2f53467"
    sha256 cellar: :any,                 sonoma:         "b72c5f218b041f54c76c653b016581e960badf100319825daf81d01aa2f27b0c"
    sha256 cellar: :any,                 ventura:        "b72c5f218b041f54c76c653b016581e960badf100319825daf81d01aa2f27b0c"
    sha256 cellar: :any,                 monterey:       "b72c5f218b041f54c76c653b016581e960badf100319825daf81d01aa2f27b0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "949129a784491a2fb73a045b747db23c0ef0e9d8d019536894af72dd73d1e626"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin/"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath/"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end
