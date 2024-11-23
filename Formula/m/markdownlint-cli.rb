class MarkdownlintCli < Formula
  desc "CLI for Node.js style checker and lint tool for Markdown files"
  homepage "https://github.com/igorshubovych/markdownlint-cli"
  url "https://registry.npmjs.org/markdownlint-cli/-/markdownlint-cli-0.43.0.tgz"
  sha256 "75f368cda3622f32df0971f834aee6bccaa64b7d1baffce021bb962328be316b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3e5181a75b8fb131ac22c9c63635573d403a3d720ef0c72bd58cecfb3c2fe3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3e5181a75b8fb131ac22c9c63635573d403a3d720ef0c72bd58cecfb3c2fe3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a3e5181a75b8fb131ac22c9c63635573d403a3d720ef0c72bd58cecfb3c2fe3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "758ba29dba62e69b33801d519cbf6186a84320adf3e8e08bda862c9b057c22e5"
    sha256 cellar: :any_skip_relocation, ventura:       "758ba29dba62e69b33801d519cbf6186a84320adf3e8e08bda862c9b057c22e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3e5181a75b8fb131ac22c9c63635573d403a3d720ef0c72bd58cecfb3c2fe3e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test-bad.md").write <<~MARKDOWN
      # Header 1
      body
    MARKDOWN
    (testpath/"test-good.md").write <<~MARKDOWN
      # Header 1

      body
    MARKDOWN
    assert_match "MD022/blanks-around-headings Headings should be surrounded by blank lines",
                 shell_output("#{bin}/markdownlint #{testpath}/test-bad.md  2>&1", 1)
    assert_empty shell_output("#{bin}/markdownlint #{testpath}/test-good.md")
  end
end
