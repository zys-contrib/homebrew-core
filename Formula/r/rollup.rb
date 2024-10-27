class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.24.1.tgz"
  sha256 "2ff2028223a1a9ba7e1c424a4fa99a24ce09ba215bf5f33f0616b746a81ed94f"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ca6ae1bce426a8c258db0ac40328b924bac41f51c0fb772fba92e7d645ea03a3"
    sha256 cellar: :any,                 arm64_sonoma:  "ca6ae1bce426a8c258db0ac40328b924bac41f51c0fb772fba92e7d645ea03a3"
    sha256 cellar: :any,                 arm64_ventura: "ca6ae1bce426a8c258db0ac40328b924bac41f51c0fb772fba92e7d645ea03a3"
    sha256 cellar: :any,                 sonoma:        "0da3da9482e1381c6ebd7c0554057c7be11c09c75d9e0f6a4e92af25435cba91"
    sha256 cellar: :any,                 ventura:       "0da3da9482e1381c6ebd7c0554057c7be11c09c75d9e0f6a4e92af25435cba91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34110756394f5f6bbbbebdbaf5f21d422beb5b89b2e80ae7bd62e01d9b21e3b2"
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
