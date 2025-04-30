class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/cli/-/cli-7.27.1.tgz"
  sha256 "5c8852751b06b0edbe0b9185af46d7c03ecc59839cf967159e86314ae126877a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b58e39c5905caed63d460f42e1eb89944a8c974d437ad7fcdf34ac0b7c88bec5"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"script.js").write <<~JS
      [1,2,3].map(n => n + 1);
    JS

    system bin/"babel", "script.js", "--out-file", "script-compiled.js"
    assert_path_exists testpath/"script-compiled.js", "script-compiled.js was not generated"
  end
end
