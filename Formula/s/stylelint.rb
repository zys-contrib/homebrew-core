class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-16.13.2.tgz"
  sha256 "7ac750eff139d8a54f11ddefd3e6ed388858352b3ab96717f1b968f15399e6b3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "239aa378f4a7dbc0319e2aba5494e179af7bb8100b639d2d44ce4b645e62cd02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "239aa378f4a7dbc0319e2aba5494e179af7bb8100b639d2d44ce4b645e62cd02"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "239aa378f4a7dbc0319e2aba5494e179af7bb8100b639d2d44ce4b645e62cd02"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a85770d03ed3316a5077ff29bd79bf2169dba9e7d896bf2ce83bbf11a5420ff"
    sha256 cellar: :any_skip_relocation, ventura:       "0a85770d03ed3316a5077ff29bd79bf2169dba9e7d896bf2ce83bbf11a5420ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "239aa378f4a7dbc0319e2aba5494e179af7bb8100b639d2d44ce4b645e62cd02"
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
