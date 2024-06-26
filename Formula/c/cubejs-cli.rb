require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.53.tgz"
  sha256 "7364f6356dd1ccca4d89741cff7f4b53c7b99c2d8bc08065666b03b190512844"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2a75fbb6bc2e114c4c49aeff2b3b240b4960e146d021c7d150814de427373413"
    sha256 cellar: :any,                 arm64_ventura:  "2a75fbb6bc2e114c4c49aeff2b3b240b4960e146d021c7d150814de427373413"
    sha256 cellar: :any,                 arm64_monterey: "2a75fbb6bc2e114c4c49aeff2b3b240b4960e146d021c7d150814de427373413"
    sha256 cellar: :any,                 sonoma:         "e3f9bc896317bdf0ee5fc209a2978ace617c76237e89e250594924924cd00d18"
    sha256 cellar: :any,                 ventura:        "e3f9bc896317bdf0ee5fc209a2978ace617c76237e89e250594924924cd00d18"
    sha256 cellar: :any,                 monterey:       "e3f9bc896317bdf0ee5fc209a2978ace617c76237e89e250594924924cd00d18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d15ed8f219861c0822e04191ae8a811e77d5f8251c5a8fd8b6f8a564bc4b5056"
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
