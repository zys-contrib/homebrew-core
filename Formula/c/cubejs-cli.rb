class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.29.tgz"
  sha256 "46b5527b5fbdcf842a1b0c729a66aa621abba9110f45531a176d81f1182ccc52"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "11c91e368b3d773a6a031246a9666feb49f16db9e8d012258be0eb47dbe9899e"
    sha256 cellar: :any,                 arm64_sonoma:  "11c91e368b3d773a6a031246a9666feb49f16db9e8d012258be0eb47dbe9899e"
    sha256 cellar: :any,                 arm64_ventura: "11c91e368b3d773a6a031246a9666feb49f16db9e8d012258be0eb47dbe9899e"
    sha256 cellar: :any,                 sonoma:        "8aa2b3e44508be73fd67fd05397086941b1898d34320af62d9bc37e21db2d789"
    sha256 cellar: :any,                 ventura:       "8aa2b3e44508be73fd67fd05397086941b1898d34320af62d9bc37e21db2d789"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0812b99b04963b15a5064bf60e026dbcb970f2d697365f0cc5e5d1825b7d66d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "712d32ee97cd360625fb0775b5ee8501ef4185dd2d70712526aec2013fd23e2e"
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
