class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.27.0.tgz"
  sha256 "f12e2767b6e3677a9633ffd4c65669b75af3e369b939eb8f363891f0e2fea5c3"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2e5edb388f679e233a8a8527980cdff7b2f52b74d1600dadcf369d6ca2d7b34f"
    sha256 cellar: :any,                 arm64_sonoma:  "2e5edb388f679e233a8a8527980cdff7b2f52b74d1600dadcf369d6ca2d7b34f"
    sha256 cellar: :any,                 arm64_ventura: "2e5edb388f679e233a8a8527980cdff7b2f52b74d1600dadcf369d6ca2d7b34f"
    sha256 cellar: :any,                 sonoma:        "ccda7b9726169405bdec6fb81ebc8a2c184d80899cdd25ce3c62f1db1f1d8618"
    sha256 cellar: :any,                 ventura:       "ccda7b9726169405bdec6fb81ebc8a2c184d80899cdd25ce3c62f1db1f1d8618"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95133385342e38a139fe68e5dbfb963a9c0339a70f8dfb7819ef2fd959f30877"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    deuniversalize_machos
  end

  test do
    (testpath/"test/main.js").write <<~EOS
      import foo from './foo.js';
      export default function () {
        console.log(foo);
      }
    EOS

    (testpath/"test/foo.js").write <<~EOS
      export default 'hello world!';
    EOS

    expected = <<~EOS
      'use strict';

      var foo = 'hello world!';

      function main () {
        console.log(foo);
      }

      module.exports = main;
    EOS

    assert_equal expected, shell_output("#{bin}/rollup #{testpath}/test/main.js -f cjs")
  end
end
