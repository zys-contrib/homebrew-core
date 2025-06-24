class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.24.tgz"
  sha256 "c7ed0c4c4b0ae4f3ee943fc0416b04066acb62e0c527d23506e97ef15d3d349a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3d241f54ab35c50ae3499c2b907bc7858bf069de155ccdcef1679fe076327fe0"
    sha256 cellar: :any,                 arm64_sonoma:  "3d241f54ab35c50ae3499c2b907bc7858bf069de155ccdcef1679fe076327fe0"
    sha256 cellar: :any,                 arm64_ventura: "3d241f54ab35c50ae3499c2b907bc7858bf069de155ccdcef1679fe076327fe0"
    sha256 cellar: :any,                 sonoma:        "223fb9a9197417ca98e1af2c9494ded9ec72c0a880f1bda30dd0ad360f9ec4cf"
    sha256 cellar: :any,                 ventura:       "223fb9a9197417ca98e1af2c9494ded9ec72c0a880f1bda30dd0ad360f9ec4cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80aff9c33d7382c8e8ff6581ca7b7d339e790966bc28234367f794292980a81f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04c7af038b3e5860e91b45f9dd942f8b18b039cb4ab445f95d1a3b97a6d4f1e9"
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
