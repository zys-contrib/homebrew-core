require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.46.tgz"
  sha256 "fcda07165b25d21a42a964f1c4d8dd80fdfdd24001fd8bf24c076dcbde531dd3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1519875b88655216ae39532223b1a90b812743a59d2b8cd0cebaf23f212985d0"
    sha256 cellar: :any,                 arm64_ventura:  "1519875b88655216ae39532223b1a90b812743a59d2b8cd0cebaf23f212985d0"
    sha256 cellar: :any,                 arm64_monterey: "1519875b88655216ae39532223b1a90b812743a59d2b8cd0cebaf23f212985d0"
    sha256 cellar: :any,                 sonoma:         "635719db5c0a9a89b50cebf6296dbe974c3ec7799eb29d3fb0aab0a02c74917d"
    sha256 cellar: :any,                 ventura:        "635719db5c0a9a89b50cebf6296dbe974c3ec7799eb29d3fb0aab0a02c74917d"
    sha256 cellar: :any,                 monterey:       "635719db5c0a9a89b50cebf6296dbe974c3ec7799eb29d3fb0aab0a02c74917d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb0412124d7317c4fdf228d0065334dca9d7d04e3481eb783d42ddf29360c8b4"
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
