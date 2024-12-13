class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-9.17.0.tgz"
  sha256 "1f5dfb1a392972604ee2b4dbcff6c7a9413e06804f130ac4025203fa7015dc2a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7c909d940e810a02c1d5137140ad0ba81a634b3106cfab9c20ddd9c32fcb182"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7c909d940e810a02c1d5137140ad0ba81a634b3106cfab9c20ddd9c32fcb182"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f7c909d940e810a02c1d5137140ad0ba81a634b3106cfab9c20ddd9c32fcb182"
    sha256 cellar: :any_skip_relocation, sonoma:        "eecb0997fcee4d6f28ff75633fd170eaaa61449bb296e239e54a5acc1e86dbe1"
    sha256 cellar: :any_skip_relocation, ventura:       "eecb0997fcee4d6f28ff75633fd170eaaa61449bb296e239e54a5acc1e86dbe1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7c909d940e810a02c1d5137140ad0ba81a634b3106cfab9c20ddd9c32fcb182"
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
