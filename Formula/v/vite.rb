class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-6.0.8.tgz"
  sha256 "7e7be275e3a257cf88c5a5ed5de65a2d1785f79b6bc06e873f0e0d1c3a164ce7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3015b63c67275ede95accdaf2be1fa31b7cac2f9d5ce8c2d5f8c317bf88d07cb"
    sha256 cellar: :any,                 arm64_sonoma:  "3015b63c67275ede95accdaf2be1fa31b7cac2f9d5ce8c2d5f8c317bf88d07cb"
    sha256 cellar: :any,                 arm64_ventura: "3015b63c67275ede95accdaf2be1fa31b7cac2f9d5ce8c2d5f8c317bf88d07cb"
    sha256 cellar: :any,                 sonoma:        "f96aab0e100e1684c14d47be395c1430dc0a1bc450148f33b1e9675f9dc10250"
    sha256 cellar: :any,                 ventura:       "f96aab0e100e1684c14d47be395c1430dc0a1bc450148f33b1e9675f9dc10250"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad1a8e8e3a02cf038f2bb9ef7215f17d3d457c359b664d05d526ca433b41b4f2"
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
