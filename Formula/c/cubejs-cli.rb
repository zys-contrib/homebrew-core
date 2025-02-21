class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.2.9.tgz"
  sha256 "d5cb979f934e41c04e93bdce86fbb0293206df8197d0d5f76c55044002e0431e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1e622705ad57514107e3d5cab3e808cb1af1757bce1d32f258ae271e9cd41a88"
    sha256 cellar: :any,                 arm64_sonoma:  "1e622705ad57514107e3d5cab3e808cb1af1757bce1d32f258ae271e9cd41a88"
    sha256 cellar: :any,                 arm64_ventura: "1e622705ad57514107e3d5cab3e808cb1af1757bce1d32f258ae271e9cd41a88"
    sha256 cellar: :any,                 sonoma:        "1267de3a0b57916c79750597d7c12e194bd099803f0d592685b31d3b170af870"
    sha256 cellar: :any,                 ventura:       "1267de3a0b57916c79750597d7c12e194bd099803f0d592685b31d3b170af870"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d10fccdd4852642caa210b67f75f761106e65947d2b1caa9c31dda39a1ea131d"
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
