require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.48.tgz"
  sha256 "6f7eeb5cff26fd1d17c1306ed722b569ded4d0e5749dca18d09e008b5e22c73b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3b6962025c90de9999e4ed9058c27a3e4a275b69af39425aae2b12be4d50fb74"
    sha256 cellar: :any,                 arm64_ventura:  "3b6962025c90de9999e4ed9058c27a3e4a275b69af39425aae2b12be4d50fb74"
    sha256 cellar: :any,                 arm64_monterey: "3b6962025c90de9999e4ed9058c27a3e4a275b69af39425aae2b12be4d50fb74"
    sha256 cellar: :any,                 sonoma:         "3ffd0a6f6cbbb0449881f2ad668c83c2e2eca0980368fe39b7c66a24f83c4a4d"
    sha256 cellar: :any,                 ventura:        "3ffd0a6f6cbbb0449881f2ad668c83c2e2eca0980368fe39b7c66a24f83c4a4d"
    sha256 cellar: :any,                 monterey:       "3ffd0a6f6cbbb0449881f2ad668c83c2e2eca0980368fe39b7c66a24f83c4a4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "459ae99e6eb6e8e5cba84ee86a84843d23e1340a02ab1b6e2bbeb11c498091b8"
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
