class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.4.0.tgz"
  sha256 "53a66a1e228947413fc19f7f86c3e31a7755645d1573f41fc7aa8df93d6a7c03"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "c2d7e75fb269ed66c854862f5bed0090cb24f7298cd59e4316c0e06c9ca9a552"
    sha256 cellar: :any,                 arm64_ventura:  "c2d7e75fb269ed66c854862f5bed0090cb24f7298cd59e4316c0e06c9ca9a552"
    sha256 cellar: :any,                 arm64_monterey: "c2d7e75fb269ed66c854862f5bed0090cb24f7298cd59e4316c0e06c9ca9a552"
    sha256 cellar: :any,                 sonoma:         "b64f5beb389ef7d332e2838a8fea319b387f478890e1ba7908eda471efaa35ac"
    sha256 cellar: :any,                 ventura:        "b64f5beb389ef7d332e2838a8fea319b387f478890e1ba7908eda471efaa35ac"
    sha256 cellar: :any,                 monterey:       "b64f5beb389ef7d332e2838a8fea319b387f478890e1ba7908eda471efaa35ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fdb5ca2b4c5df772ccd91c3bb9fdfef8f64faffb45f0c7bd7c354ae33a68e95"
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
