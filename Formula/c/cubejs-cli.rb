class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.68.tgz"
  sha256 "b8fef691c9436bdcdc28d47a6eec93fbd9c09e816e33c5e4d807c1d5a05fed9a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a18454abcdf3b0c682443a65bc48d9cb6f283c144fa355a65768ef5ab67dd546"
    sha256 cellar: :any,                 arm64_ventura:  "a18454abcdf3b0c682443a65bc48d9cb6f283c144fa355a65768ef5ab67dd546"
    sha256 cellar: :any,                 arm64_monterey: "a18454abcdf3b0c682443a65bc48d9cb6f283c144fa355a65768ef5ab67dd546"
    sha256 cellar: :any,                 sonoma:         "7a6211eb8a45ecf9a6da7a6372405d8e970ce7ebcc30d72037d3b0b21660213c"
    sha256 cellar: :any,                 ventura:        "7a6211eb8a45ecf9a6da7a6372405d8e970ce7ebcc30d72037d3b0b21660213c"
    sha256 cellar: :any,                 monterey:       "7a6211eb8a45ecf9a6da7a6372405d8e970ce7ebcc30d72037d3b0b21660213c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7565b195533058300ea1397a43eea1e7bd130cf5f5a3a36f89eaa2367a97e038"
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
