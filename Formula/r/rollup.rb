class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.27.4.tgz"
  sha256 "3fffae23a91d75bed4ec61ae6880c1f82170bc5794ef51e0ae282aeeb4171afb"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "36fbf748fc14fc0caa76625da904550b74b97c144e80c9825abeaa18efbfce0f"
    sha256 cellar: :any,                 arm64_sonoma:  "36fbf748fc14fc0caa76625da904550b74b97c144e80c9825abeaa18efbfce0f"
    sha256 cellar: :any,                 arm64_ventura: "36fbf748fc14fc0caa76625da904550b74b97c144e80c9825abeaa18efbfce0f"
    sha256 cellar: :any,                 sonoma:        "cc2968baf408ca566181dbd63b6fc714b0f7e31b8f7404477ef308582cf19545"
    sha256 cellar: :any,                 ventura:       "cc2968baf408ca566181dbd63b6fc714b0f7e31b8f7404477ef308582cf19545"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64f6b10162e24f12d70e350a56bd79e5ed38d7d806dfde6ac0c484ecc7d52a1b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    deuniversalize_machos
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
