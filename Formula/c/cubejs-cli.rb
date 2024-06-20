require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.51.tgz"
  sha256 "1ab683f1ee7b4780f73c4c8a4ebea3608acd21806f69e6ebe2b9ab69c8c7f9b7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "29a8a12d65d1661c1371c18609d94fae141afc97c7d8f5fd012f39a438196b20"
    sha256 cellar: :any,                 arm64_ventura:  "29a8a12d65d1661c1371c18609d94fae141afc97c7d8f5fd012f39a438196b20"
    sha256 cellar: :any,                 arm64_monterey: "29a8a12d65d1661c1371c18609d94fae141afc97c7d8f5fd012f39a438196b20"
    sha256 cellar: :any,                 sonoma:         "0e5790abffa8fdaa4511ef9a516d9737485e855e1bea18d19ca15a3c3ee07476"
    sha256 cellar: :any,                 ventura:        "0e5790abffa8fdaa4511ef9a516d9737485e855e1bea18d19ca15a3c3ee07476"
    sha256 cellar: :any,                 monterey:       "0e5790abffa8fdaa4511ef9a516d9737485e855e1bea18d19ca15a3c3ee07476"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc0d1224b3f8179a108235fa41a6732c010a3afc43275431e4b6e2ad278f1b1c"
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
