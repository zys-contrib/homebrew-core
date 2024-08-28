class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-16.9.0.tgz"
  sha256 "8d2bea6367d235831e4a47d9a94879aba292b6a4cdc3688da408faa28d0dd313"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "65f2d07ce324284607cb2f42d8edfeec235a5f1babfa60f539456c3686469f0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "65f2d07ce324284607cb2f42d8edfeec235a5f1babfa60f539456c3686469f0a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65f2d07ce324284607cb2f42d8edfeec235a5f1babfa60f539456c3686469f0a"
    sha256 cellar: :any_skip_relocation, sonoma:         "db257527556aac0815e7e2bee439600344bd5380736803f52c5ea01fb70736b7"
    sha256 cellar: :any_skip_relocation, ventura:        "db257527556aac0815e7e2bee439600344bd5380736803f52c5ea01fb70736b7"
    sha256 cellar: :any_skip_relocation, monterey:       "db257527556aac0815e7e2bee439600344bd5380736803f52c5ea01fb70736b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65f2d07ce324284607cb2f42d8edfeec235a5f1babfa60f539456c3686469f0a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/".stylelintrc").write <<~EOS
      {
        "rules": {
          "block-no-empty": true
        }
      }
    EOS

    (testpath/"test.css").write <<~EOS
      a {
      }
    EOS

    output = shell_output("#{bin}/stylelint test.css 2>&1", 2)
    assert_match "Unexpected empty block", output

    assert_match version.to_s, shell_output("#{bin}/stylelint --version")
  end
end
