class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.4.tgz"
  sha256 "024fde0c87825f743bf63de831f8561cd4e6c0a07fb45a40df1e1c60d9eebc7b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d6ede8c829aca7d1440e87fc11e15369fa62effe8d163deaeb7bbcdacd99b40e"
    sha256 cellar: :any,                 arm64_sonoma:  "d6ede8c829aca7d1440e87fc11e15369fa62effe8d163deaeb7bbcdacd99b40e"
    sha256 cellar: :any,                 arm64_ventura: "d6ede8c829aca7d1440e87fc11e15369fa62effe8d163deaeb7bbcdacd99b40e"
    sha256 cellar: :any,                 sonoma:        "13f841b3c8dc03f13ad979ba5644a2f049c7a28e1d0d316cb17e885594cd6820"
    sha256 cellar: :any,                 ventura:       "13f841b3c8dc03f13ad979ba5644a2f049c7a28e1d0d316cb17e885594cd6820"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "393df324a7bc68d296335bbae748acae89d1a817e4a4b2c167f48b28e8480604"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e7b65a116df58446137815473d579574c3cf700d0ea7738e71e0f15e27dc3a5"
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
