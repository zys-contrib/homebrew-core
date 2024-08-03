class Solhint < Formula
  desc "Linter for Solidity code"
  homepage "https://protofire.github.io/solhint/"
  url "https://registry.npmjs.org/solhint/-/solhint-5.0.3.tgz"
  sha256 "dd26c50bb8c53e6869b424107012fcd20e109718fd40e9bbc15c6efa8c5863df"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "882122bc044a0bf518f9d059ac50307bbc6ad8afc0392bb8086375f8d01b1575"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "882122bc044a0bf518f9d059ac50307bbc6ad8afc0392bb8086375f8d01b1575"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "882122bc044a0bf518f9d059ac50307bbc6ad8afc0392bb8086375f8d01b1575"
    sha256 cellar: :any_skip_relocation, sonoma:         "bb2b6f082e264891758f7cbe3ae8b38ac721bc76de86ff2ee4ceec0578f61eb7"
    sha256 cellar: :any_skip_relocation, ventura:        "bb2b6f082e264891758f7cbe3ae8b38ac721bc76de86ff2ee4ceec0578f61eb7"
    sha256 cellar: :any_skip_relocation, monterey:       "bb2b6f082e264891758f7cbe3ae8b38ac721bc76de86ff2ee4ceec0578f61eb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b56dff559bba772052a1d8928b9834944c6b1e7f1bf72a194420b193ec3f5c6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    test_config = testpath/".solhint.json"
    test_config.write <<~EOS
      {
        "rules": {
          "no-empty-blocks": "error"
        }
      }
    EOS

    (testpath/"test.sol").write <<~EOS
      pragma solidity ^0.4.0;
      contract Test {
        function test() {
        }
      }
    EOS
    assert_match "error  Code contains empty blocks  no-empty-blocks",
      shell_output("#{bin}/solhint --config #{test_config} test.sol 2>&1", 1)
  end
end
