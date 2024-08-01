require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.19.2.tgz"
  sha256 "352fcb85b3d0d5e5715ca9800ccba12448528d95a2ff278485f23f5ba9b44449"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0669a1348a8ad16b9827f4f66645eee51cb04c1e0d2622934ab6f0b70e935360"
    sha256 cellar: :any,                 arm64_ventura:  "0669a1348a8ad16b9827f4f66645eee51cb04c1e0d2622934ab6f0b70e935360"
    sha256 cellar: :any,                 arm64_monterey: "0669a1348a8ad16b9827f4f66645eee51cb04c1e0d2622934ab6f0b70e935360"
    sha256 cellar: :any,                 sonoma:         "a310f777a3f5b0ac9801c6b7edfbb9e83623980b6170b161b4cb7a2c78e982b6"
    sha256 cellar: :any,                 ventura:        "a310f777a3f5b0ac9801c6b7edfbb9e83623980b6170b161b4cb7a2c78e982b6"
    sha256 cellar: :any,                 monterey:       "a310f777a3f5b0ac9801c6b7edfbb9e83623980b6170b161b4cb7a2c78e982b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf3eb04b548547d97e01b9b55bdc447051901be25a293a84163c3acbbd61479e"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
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
