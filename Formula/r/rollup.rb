class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.33.0.tgz"
  sha256 "bb0425a754170be74548983c084040e82febfbbb4edd76c6e1318a9fd52dc3ab"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f39205fc72dca597d246f86a208afe4cbeaabc2fe0c9b964ab37e91329267cb8"
    sha256 cellar: :any,                 arm64_sonoma:  "f39205fc72dca597d246f86a208afe4cbeaabc2fe0c9b964ab37e91329267cb8"
    sha256 cellar: :any,                 arm64_ventura: "f39205fc72dca597d246f86a208afe4cbeaabc2fe0c9b964ab37e91329267cb8"
    sha256 cellar: :any,                 sonoma:        "088855496f688613e1c666b52210ef5f9f1b7a8db39f36d60513f8c6982a32cd"
    sha256 cellar: :any,                 ventura:       "088855496f688613e1c666b52210ef5f9f1b7a8db39f36d60513f8c6982a32cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7da1f53923d0142dc14100c1fffe9f31f3abd6d2a1ba4b1bd4d66100e560ea4f"
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
