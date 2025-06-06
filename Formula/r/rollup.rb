class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.41.2.tgz"
  sha256 "23aed1d2d1ce0ba43634c50f9147fff9184df950bb18e89e45347c4504a7c56e"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "05ac5627d16d5be56506952a70fef84c9eb5b4ab1b014f7553a3309cbbe8e8a9"
    sha256 cellar: :any,                 arm64_sonoma:  "05ac5627d16d5be56506952a70fef84c9eb5b4ab1b014f7553a3309cbbe8e8a9"
    sha256 cellar: :any,                 arm64_ventura: "05ac5627d16d5be56506952a70fef84c9eb5b4ab1b014f7553a3309cbbe8e8a9"
    sha256 cellar: :any,                 sonoma:        "bb8e13f60724f7f0d1cc619442b82b38262f801ad2f125ffbb0bfce8a73e5f7f"
    sha256 cellar: :any,                 ventura:       "bb8e13f60724f7f0d1cc619442b82b38262f801ad2f125ffbb0bfce8a73e5f7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "919f48a63a8e528bbf6006413696694f912536a052850e45cef381aa0aa2b165"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2db8d406e339015b15803d949571c6881cccb09ea02a98d47ef40c8331f105e"
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
