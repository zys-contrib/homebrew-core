class Solhint < Formula
  desc "Linter for Solidity code"
  homepage "https://protofire.github.io/solhint/"
  url "https://registry.npmjs.org/solhint/-/solhint-5.0.5.tgz"
  sha256 "dacb00c5a84b65b65370b8531480b1d25171dc97b45a246cf943ca8b4f91488d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1de17efd7be77bcdb4febe876c3036d35007ed90be973407421cb0151b952ce3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1de17efd7be77bcdb4febe876c3036d35007ed90be973407421cb0151b952ce3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1de17efd7be77bcdb4febe876c3036d35007ed90be973407421cb0151b952ce3"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3803bfe91e604111ef74d395231c3fff1c7715dad84fd55524ebe2432325d22"
    sha256 cellar: :any_skip_relocation, ventura:       "d3803bfe91e604111ef74d395231c3fff1c7715dad84fd55524ebe2432325d22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1de17efd7be77bcdb4febe876c3036d35007ed90be973407421cb0151b952ce3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    test_config = testpath/".solhint.json"
    test_config.write <<~JSON
      {
        "rules": {
          "no-empty-blocks": "error"
        }
      }
    JSON

    (testpath/"test.sol").write <<~SOLIDITY
      pragma solidity ^0.4.0;
      contract Test {
        function test() {
        }
      }
    SOLIDITY
    assert_match "error  Code contains empty blocks  no-empty-blocks",
      shell_output("#{bin}/solhint --config #{test_config} test.sol 2>&1", 1)
  end
end
