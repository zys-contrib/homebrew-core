class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.4.10.tgz"
  sha256 "2ef8583733cc62afbe9beb48e0a4cfe08518e02883b6120065ae0c81877dc7ec"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "305675ca06c17bb99275872f80bd79e33b53602c4c37dcee2139faf6395d3048"
    sha256 cellar: :any,                 arm64_sonoma:  "305675ca06c17bb99275872f80bd79e33b53602c4c37dcee2139faf6395d3048"
    sha256 cellar: :any,                 arm64_ventura: "305675ca06c17bb99275872f80bd79e33b53602c4c37dcee2139faf6395d3048"
    sha256 cellar: :any,                 sonoma:        "2d71fbcbce50bdb337368547734f5c3c96a9959496013065b25ec36045e71267"
    sha256 cellar: :any,                 ventura:       "2d71fbcbce50bdb337368547734f5c3c96a9959496013065b25ec36045e71267"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77c1500e1a0b035c8ab976957d312af9d1cfc6597fd5826eec68ede7ea9284ec"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/vite optimize --force")
    assert_match "Forced re-optimization of dependencies", output

    output = shell_output("#{bin}/vite optimize")
    assert_match "Hash is consistent. Skipping.", output

    assert_match version.to_s, shell_output("#{bin}/vite --version")
  end
end
