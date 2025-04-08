class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.2.32.tgz"
  sha256 "f26275b9e6c9a42ee99c2802398ffd5db852599912a1a12b8cdfcef406aed765"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c7febef6b105f2da30eb5c40b38e3f31462253f8a1a20060095da9eaa72af317"
    sha256 cellar: :any,                 arm64_sonoma:  "c7febef6b105f2da30eb5c40b38e3f31462253f8a1a20060095da9eaa72af317"
    sha256 cellar: :any,                 arm64_ventura: "c7febef6b105f2da30eb5c40b38e3f31462253f8a1a20060095da9eaa72af317"
    sha256 cellar: :any,                 sonoma:        "3af47a2f5390ea8bf845d131f47acee79f9a5e80854fa1b21da5c3f3d70edd78"
    sha256 cellar: :any,                 ventura:       "3af47a2f5390ea8bf845d131f47acee79f9a5e80854fa1b21da5c3f3d70edd78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8cdeb1ad6998b59b2344b6abf91ca6fa62c0f45259f7b820537c07cc0ac6e8e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eba2ae986dbc668003b82cbbdceb5d03511400949a78d53aed1da391f962c3b0"
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
