class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-9.29.0.tgz"
  sha256 "71597d5fd0865e8d5d26317923f6243c0787165f6326871b69f4c330da03a580"
  license "MIT"
  head "https://github.com/eslint/eslint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96045bab80424e89e6d681edc946963e51c0b86a9801f9561aa8c66eac4d16b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96045bab80424e89e6d681edc946963e51c0b86a9801f9561aa8c66eac4d16b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "96045bab80424e89e6d681edc946963e51c0b86a9801f9561aa8c66eac4d16b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "3994eee94ea4f5744e4df11142102f6c6e04faafadc743a0d1aff4499a3322e3"
    sha256 cellar: :any_skip_relocation, ventura:       "3994eee94ea4f5744e4df11142102f6c6e04faafadc743a0d1aff4499a3322e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96045bab80424e89e6d681edc946963e51c0b86a9801f9561aa8c66eac4d16b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96045bab80424e89e6d681edc946963e51c0b86a9801f9561aa8c66eac4d16b8"
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
