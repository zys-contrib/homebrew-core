class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.33.0.tgz"
  sha256 "bb0425a754170be74548983c084040e82febfbbb4edd76c6e1318a9fd52dc3ab"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f65b63bfee527fc96186dcbe7e5e45b4947b5c700f1522e7db5cce31ea66eecd"
    sha256 cellar: :any,                 arm64_sonoma:  "f65b63bfee527fc96186dcbe7e5e45b4947b5c700f1522e7db5cce31ea66eecd"
    sha256 cellar: :any,                 arm64_ventura: "f65b63bfee527fc96186dcbe7e5e45b4947b5c700f1522e7db5cce31ea66eecd"
    sha256 cellar: :any,                 sonoma:        "41bfcb39263e01b6eb0521a187856efcf11dc1273b6c2e4579cadf1ce01612b8"
    sha256 cellar: :any,                 ventura:       "41bfcb39263e01b6eb0521a187856efcf11dc1273b6c2e4579cadf1ce01612b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48af3e6f85eaf62fe4857c25e4b08647d96a959077d51f4f9f95e10bff4de270"
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
