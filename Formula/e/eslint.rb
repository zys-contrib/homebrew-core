class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-9.14.0.tgz"
  sha256 "9f9db5976b508c2ece3a3563d6cc2c0d7fad81b0a18661cf3d007b29a1df6893"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f6577bbd063b50795835b8d0acae3e33f103169e5a127c6a0a37a93beccb605"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f6577bbd063b50795835b8d0acae3e33f103169e5a127c6a0a37a93beccb605"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f6577bbd063b50795835b8d0acae3e33f103169e5a127c6a0a37a93beccb605"
    sha256 cellar: :any_skip_relocation, sonoma:        "a562ad08a14b2dca32ce614f6afe61412d4b943654042fddc1738f99af6b37af"
    sha256 cellar: :any_skip_relocation, ventura:       "a562ad08a14b2dca32ce614f6afe61412d4b943654042fddc1738f99af6b37af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f6577bbd063b50795835b8d0acae3e33f103169e5a127c6a0a37a93beccb605"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
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
