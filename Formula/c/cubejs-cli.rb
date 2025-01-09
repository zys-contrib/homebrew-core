class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.1.13.tgz"
  sha256 "bbbbb95bc0100516ff168642a578cb6a9fa72ab4802f5507ec7f7db7723773ff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c08fb4600c9ee4fc88f0c81b988746b1edfd895f524632cc06cdfc2322421e14"
    sha256 cellar: :any,                 arm64_sonoma:  "c08fb4600c9ee4fc88f0c81b988746b1edfd895f524632cc06cdfc2322421e14"
    sha256 cellar: :any,                 arm64_ventura: "c08fb4600c9ee4fc88f0c81b988746b1edfd895f524632cc06cdfc2322421e14"
    sha256 cellar: :any,                 sonoma:        "04eb3152056a332e07a57678b9e80107bd1df4e1d8a8fa3d932477d757d4b976"
    sha256 cellar: :any,                 ventura:       "04eb3152056a332e07a57678b9e80107bd1df4e1d8a8fa3d932477d757d4b976"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44cf5611166351ddca9a424f0fe4d2a733c5f24cb7cf1d3c51b344f44f12af57"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end
