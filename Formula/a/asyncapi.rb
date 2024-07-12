require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-2.1.0.tgz"
  sha256 "b56144cc164a4410f8615768b3f894246cba64aad7039648cfbc8e4422aa0ae5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c52773b405d505339aa61aed282ae0e25d41d42ad3ae048b606dfcc9cd3a3d40"
    sha256 cellar: :any,                 arm64_ventura:  "c52773b405d505339aa61aed282ae0e25d41d42ad3ae048b606dfcc9cd3a3d40"
    sha256 cellar: :any,                 arm64_monterey: "c52773b405d505339aa61aed282ae0e25d41d42ad3ae048b606dfcc9cd3a3d40"
    sha256 cellar: :any,                 sonoma:         "87b4615d7fb0e05f202a82f819c5f006c8bb9b1fa2ef5ec6f110d61d8ca61628"
    sha256 cellar: :any,                 ventura:        "87b4615d7fb0e05f202a82f819c5f006c8bb9b1fa2ef5ec6f110d61d8ca61628"
    sha256 cellar: :any,                 monterey:       "87b4615d7fb0e05f202a82f819c5f006c8bb9b1fa2ef5ec6f110d61d8ca61628"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87136c03b92c260636a6cd3f89807b9cb6bc601fe04ee480851ca0a08ea1b767"
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
