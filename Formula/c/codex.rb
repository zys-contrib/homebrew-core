class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"
  url "https://registry.npmjs.org/@openai/codex/-/codex-0.1.2505161243.tgz"
  sha256 "b47ac6af5a516f7685eddd51dfd69df31c03859e7692fbb79716377cd34eeaa1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d7f2f1722198aa35d5a4e56be49cba83ace3fbbdb3759357a6b14a1adf11935"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d7f2f1722198aa35d5a4e56be49cba83ace3fbbdb3759357a6b14a1adf11935"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9d7f2f1722198aa35d5a4e56be49cba83ace3fbbdb3759357a6b14a1adf11935"
    sha256 cellar: :any_skip_relocation, sonoma:        "6731cb1d4c553b1310fa5070feea2a44ef7e9297c34f29400409dddb93935f84"
    sha256 cellar: :any_skip_relocation, ventura:       "6731cb1d4c553b1310fa5070feea2a44ef7e9297c34f29400409dddb93935f84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d7f2f1722198aa35d5a4e56be49cba83ace3fbbdb3759357a6b14a1adf11935"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d7f2f1722198aa35d5a4e56be49cba83ace3fbbdb3759357a6b14a1adf11935"
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
