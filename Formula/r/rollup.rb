class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.34.4.tgz"
  sha256 "a9b98d5de18a43a74a4c9805ee7a03f3de84fada15f1b20cdbebbdbbc20ffdee"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f4037286b37121b4645f3a5c0429aa833c30193df75be4124512dae5dbe997e6"
    sha256 cellar: :any,                 arm64_sonoma:  "f4037286b37121b4645f3a5c0429aa833c30193df75be4124512dae5dbe997e6"
    sha256 cellar: :any,                 arm64_ventura: "f4037286b37121b4645f3a5c0429aa833c30193df75be4124512dae5dbe997e6"
    sha256 cellar: :any,                 sonoma:        "14a2f227cf1a13f457532af820b447bebf12a76568606e3a5199cde4d7a7688e"
    sha256 cellar: :any,                 ventura:       "14a2f227cf1a13f457532af820b447bebf12a76568606e3a5199cde4d7a7688e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41560747f65aba00db5a47d74ec68938951d2326014c00f88cb9d4b79535a631"
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
