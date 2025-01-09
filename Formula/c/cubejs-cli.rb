class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.1.13.tgz"
  sha256 "bbbbb95bc0100516ff168642a578cb6a9fa72ab4802f5507ec7f7db7723773ff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3e8f404a7bcc751e13deb1880cb83631c2fd91e73f9055517d2f0263c91d6622"
    sha256 cellar: :any,                 arm64_sonoma:  "3e8f404a7bcc751e13deb1880cb83631c2fd91e73f9055517d2f0263c91d6622"
    sha256 cellar: :any,                 arm64_ventura: "3e8f404a7bcc751e13deb1880cb83631c2fd91e73f9055517d2f0263c91d6622"
    sha256 cellar: :any,                 sonoma:        "975033962ec61d796f892edb03877d718947e3f5fa047f0d247b1e84e423b65b"
    sha256 cellar: :any,                 ventura:       "975033962ec61d796f892edb03877d718947e3f5fa047f0d247b1e84e423b65b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "292b319e98fccd62aff05dc9b7806250d6eb8366e2eeaa5693742013f7555929"
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
