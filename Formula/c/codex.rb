class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"
  url "https://registry.npmjs.org/@openai/codex/-/codex-0.1.2505171619.tgz"
  sha256 "2008d21ff147fbd51c3f533adbc2975c33cd6c65cffad70eddebf74d913703fc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "623d11034db513918908834fdcc155dcc2838b7395e1fa15c8ff982a67c64a98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "623d11034db513918908834fdcc155dcc2838b7395e1fa15c8ff982a67c64a98"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "623d11034db513918908834fdcc155dcc2838b7395e1fa15c8ff982a67c64a98"
    sha256 cellar: :any_skip_relocation, sonoma:        "b87f2f5c3e24dde23b3e79dd6a00ace5415deea58402b951ea0837d496637faf"
    sha256 cellar: :any_skip_relocation, ventura:       "b87f2f5c3e24dde23b3e79dd6a00ace5415deea58402b951ea0837d496637faf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "623d11034db513918908834fdcc155dcc2838b7395e1fa15c8ff982a67c64a98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "623d11034db513918908834fdcc155dcc2838b7395e1fa15c8ff982a67c64a98"
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
