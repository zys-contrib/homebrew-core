class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/cli/-/cli-7.27.2.tgz"
  sha256 "e8e435effda89bd5337945a5ecaae4aaeb8701859f30d8c07ca3ada094b586fe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f0c906814e105600181672923375e780bc28f7b2358da8ff05e212aa76cdecbd"
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
