require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.51.tgz"
  sha256 "1ab683f1ee7b4780f73c4c8a4ebea3608acd21806f69e6ebe2b9ab69c8c7f9b7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a86fe39ddadcab267a14da387a653666eca6c7295a796985e25e09810af37b09"
    sha256 cellar: :any,                 arm64_ventura:  "a86fe39ddadcab267a14da387a653666eca6c7295a796985e25e09810af37b09"
    sha256 cellar: :any,                 arm64_monterey: "a86fe39ddadcab267a14da387a653666eca6c7295a796985e25e09810af37b09"
    sha256 cellar: :any,                 sonoma:         "25eaeb8f0cde04eb6c6da4a737146848d22a725c0dc255cdc28e40774445a8a9"
    sha256 cellar: :any,                 ventura:        "25eaeb8f0cde04eb6c6da4a737146848d22a725c0dc255cdc28e40774445a8a9"
    sha256 cellar: :any,                 monterey:       "25eaeb8f0cde04eb6c6da4a737146848d22a725c0dc255cdc28e40774445a8a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79a26806b38b3778938fd842105d7c8a60ebf01e1ee4acd3c9ae170f698c599d"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end
