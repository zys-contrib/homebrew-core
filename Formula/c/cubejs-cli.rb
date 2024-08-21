class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.73.tgz"
  sha256 "5adb635b4579f5897a23d3ebe1a5034a69edb1bc29427602af5a9d4e282ae8d2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ae1143c53db8436a67ba4b7a5dc96cb91f6ce03c6c1ecd4156b209403b42469b"
    sha256 cellar: :any,                 arm64_ventura:  "ae1143c53db8436a67ba4b7a5dc96cb91f6ce03c6c1ecd4156b209403b42469b"
    sha256 cellar: :any,                 arm64_monterey: "ae1143c53db8436a67ba4b7a5dc96cb91f6ce03c6c1ecd4156b209403b42469b"
    sha256 cellar: :any,                 sonoma:         "41a6704f112bcbf0d59a7fa4f1e40b7eac64365fe9bbdd18704ac1abdd51e0b4"
    sha256 cellar: :any,                 ventura:        "41a6704f112bcbf0d59a7fa4f1e40b7eac64365fe9bbdd18704ac1abdd51e0b4"
    sha256 cellar: :any,                 monterey:       "41a6704f112bcbf0d59a7fa4f1e40b7eac64365fe9bbdd18704ac1abdd51e0b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1f36cecdcfd77207924507228cf49a58c6139c26179dd86090faeb1f4bf0dec"
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
