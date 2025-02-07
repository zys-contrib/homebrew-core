class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-9.20.0.tgz"
  sha256 "3357141d0a24d187d404d011ef16af319165af970822e988e27bbdfa1da853b1"
  license "MIT"
  head "https://github.com/eslint/eslint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c30dd67b81313d6021d23717400fb83f9a430876a49efc50c3557ca354659921"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c30dd67b81313d6021d23717400fb83f9a430876a49efc50c3557ca354659921"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c30dd67b81313d6021d23717400fb83f9a430876a49efc50c3557ca354659921"
    sha256 cellar: :any_skip_relocation, sonoma:        "043d03824b1318cd7d576f3e0338fde70259029c2059d357402d5a14af4fb8a1"
    sha256 cellar: :any_skip_relocation, ventura:       "043d03824b1318cd7d576f3e0338fde70259029c2059d357402d5a14af4fb8a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c30dd67b81313d6021d23717400fb83f9a430876a49efc50c3557ca354659921"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    # https://eslint.org/docs/latest/use/configure/configuration-files#configuration-file
    (testpath/"eslint.config.js").write("{}") # minimal config
    (testpath/"syntax-error.js").write("{}}")

    # https://eslint.org/docs/user-guide/command-line-interface#exit-codes
    output = shell_output("#{bin}/eslint syntax-error.js", 1)
    assert_match "Unexpected token }", output
  end
end
