class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.3.tgz"
  sha256 "78d770d5ff3fd190bbcc3509c6487892274e9f4f4d88c95cab0531241f938cd2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "70f8df1c98da2bda24e16ea964a4b0754b5b1d494cd19a7c43a74e7f76fbba50"
    sha256 cellar: :any,                 arm64_sonoma:  "70f8df1c98da2bda24e16ea964a4b0754b5b1d494cd19a7c43a74e7f76fbba50"
    sha256 cellar: :any,                 arm64_ventura: "70f8df1c98da2bda24e16ea964a4b0754b5b1d494cd19a7c43a74e7f76fbba50"
    sha256 cellar: :any_skip_relocation, sonoma:        "e941ca9cb8d534b87cfb4ab8a16fb4563096bde5eafc3eaa256e6ddcee0cd2a4"
    sha256 cellar: :any_skip_relocation, ventura:       "e941ca9cb8d534b87cfb4ab8a16fb4563096bde5eafc3eaa256e6ddcee0cd2a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd9073eaf5cea3a9dced3584700803969c5ad97522d47bfaaf2b8bebfc605237"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b67ca5227806f032808ec34b01e50a1416da19fccb59c7f2404ad81b71d5b83"
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
