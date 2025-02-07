class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.34.5.tgz"
  sha256 "aadf7ff06e09a9fa0d2c55871ba627f73bf42c370c1844e08114a3441b9709cb"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "397cca0a6bf2c525c47044337ee33fef17cbe06e17f654dc58ccc8368adf467c"
    sha256 cellar: :any,                 arm64_sonoma:  "397cca0a6bf2c525c47044337ee33fef17cbe06e17f654dc58ccc8368adf467c"
    sha256 cellar: :any,                 arm64_ventura: "397cca0a6bf2c525c47044337ee33fef17cbe06e17f654dc58ccc8368adf467c"
    sha256 cellar: :any,                 sonoma:        "55de71fce2b859c53fba7ec5c830f78256949dce518515a4f1ae50d4d4ab3f36"
    sha256 cellar: :any,                 ventura:       "55de71fce2b859c53fba7ec5c830f78256949dce518515a4f1ae50d4d4ab3f36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d22ab4c96882df7c422bb33ad196a00bc895c78941f0872d55d6546a678ca28c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test/main.js").write <<~JS
      import foo from './foo.js';
      export default function () {
        console.log(foo);
      }
    JS

    (testpath/"test/foo.js").write <<~JS
      export default 'hello world!';
    JS

    expected = <<~JS
      'use strict';

      var foo = 'hello world!';

      function main () {
        console.log(foo);
      }

      module.exports = main;
    JS

    assert_equal expected, shell_output("#{bin}/rollup #{testpath}/test/main.js -f cjs")
  end
end
