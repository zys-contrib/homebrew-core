class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"
  url "https://registry.npmjs.org/@openai/codex/-/codex-0.1.2505291658.tgz"
  sha256 "066a11322e815d680799330cf360bc9601deb0a40d907546c2cda9eb22cca86a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a51b6ccd85e654bb9c942cf44004d6f53bf71ff7e2569b5194a01f1f76db75f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a51b6ccd85e654bb9c942cf44004d6f53bf71ff7e2569b5194a01f1f76db75f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9a51b6ccd85e654bb9c942cf44004d6f53bf71ff7e2569b5194a01f1f76db75f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d538efeb8b6b2c659976b6dfdb78476a8778f32ee5d8c9525b8dcbe49e27792"
    sha256 cellar: :any_skip_relocation, ventura:       "9d538efeb8b6b2c659976b6dfdb78476a8778f32ee5d8c9525b8dcbe49e27792"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a51b6ccd85e654bb9c942cf44004d6f53bf71ff7e2569b5194a01f1f76db75f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a51b6ccd85e654bb9c942cf44004d6f53bf71ff7e2569b5194a01f1f76db75f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    libexec.glob("lib/node_modules/@openai/codex/bin/*")
           .each { |f| rm_r(f) if f.extname != ".js" }

    generate_completions_from_executable(bin/"codex", "completion")
  end

  test do
    # codex is a TUI application
    assert_match version.to_s, shell_output("#{bin}/codex --version")
  end
end
