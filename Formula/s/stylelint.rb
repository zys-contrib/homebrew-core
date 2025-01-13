class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-16.13.1.tgz"
  sha256 "13ec74f35424c3029b85cffcad0c5c388740d9748d15ed693724d5601fb72d02"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "076fe07bf4957545114b885b92fb17bd8a997d2de22d94082455bae45dd7ecc9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "076fe07bf4957545114b885b92fb17bd8a997d2de22d94082455bae45dd7ecc9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "076fe07bf4957545114b885b92fb17bd8a997d2de22d94082455bae45dd7ecc9"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2954e4f5fd6e8550687641019f45133fdabd7538e3787581e47c0b01a420b36"
    sha256 cellar: :any_skip_relocation, ventura:       "d2954e4f5fd6e8550687641019f45133fdabd7538e3787581e47c0b01a420b36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "076fe07bf4957545114b885b92fb17bd8a997d2de22d94082455bae45dd7ecc9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/".stylelintrc").write <<~JSON
      {
        "rules": {
          "block-no-empty": true
        }
      }
    JSON

    (testpath/"test.css").write <<~CSS
      a {
      }
    CSS

    output = shell_output("#{bin}/stylelint test.css 2>&1", 2)
    assert_match "Unexpected empty block", output

    assert_match version.to_s, shell_output("#{bin}/stylelint --version")
  end
end
