class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.2.10.tgz"
  sha256 "8347b409217169458b46420fb85e431980d4e5bd1b2efd588d6c4a3482164d62"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0d00997897dce1ab03104470122a376c6e4418f83a163e2e60ce98b9a578574d"
    sha256 cellar: :any,                 arm64_sonoma:  "0d00997897dce1ab03104470122a376c6e4418f83a163e2e60ce98b9a578574d"
    sha256 cellar: :any,                 arm64_ventura: "0d00997897dce1ab03104470122a376c6e4418f83a163e2e60ce98b9a578574d"
    sha256 cellar: :any,                 sonoma:        "947341bebfa27fd4805f0ad6631f1c6a2e8bb8bac37a261109cd4c2390dd0a56"
    sha256 cellar: :any,                 ventura:       "947341bebfa27fd4805f0ad6631f1c6a2e8bb8bac37a261109cd4c2390dd0a56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cac73b24e64d3f84a07415b77c2df4b6f36d6db35cbb778732bd1d4a032a6bb"
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
    assert_path_exists testpath/"hello-world/model/cubes/orders.yml"
  end
end
