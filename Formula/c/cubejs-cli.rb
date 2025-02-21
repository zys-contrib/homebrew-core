class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.2.8.tgz"
  sha256 "1140d0e5712550c9e8e3657c4af55680b0266b03f02d76f73a2b7dd0b373b3e6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "90da82859e9b4a8792e9347bce14af0ab5ab2b26207710e358b55216fd71367a"
    sha256 cellar: :any,                 arm64_sonoma:  "90da82859e9b4a8792e9347bce14af0ab5ab2b26207710e358b55216fd71367a"
    sha256 cellar: :any,                 arm64_ventura: "90da82859e9b4a8792e9347bce14af0ab5ab2b26207710e358b55216fd71367a"
    sha256 cellar: :any,                 sonoma:        "f3006d6a9497d1ff7481d92250e0b169bbcd0099c3f9c33b31f321aaa371be87"
    sha256 cellar: :any,                 ventura:       "f3006d6a9497d1ff7481d92250e0b169bbcd0099c3f9c33b31f321aaa371be87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b68924dc733093d8dcff5fb92a8ffa9b8deb9052d5ffcd04dff7a5fc33f87bb2"
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
