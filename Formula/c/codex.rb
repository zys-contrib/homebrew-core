class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"
  url "https://registry.npmjs.org/@openai/codex/-/codex-0.1.2505161243.tgz"
  sha256 "b47ac6af5a516f7685eddd51dfd69df31c03859e7692fbb79716377cd34eeaa1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "203d9e90dca47491c291d91b29de6dac25aa4a2bc20f3e22ed691631b57d9507"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "203d9e90dca47491c291d91b29de6dac25aa4a2bc20f3e22ed691631b57d9507"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "203d9e90dca47491c291d91b29de6dac25aa4a2bc20f3e22ed691631b57d9507"
    sha256 cellar: :any_skip_relocation, sonoma:        "d803af8c4ae43bb3c54ebc59517bd2c76a889d241aab9ad81beab98eee098ed6"
    sha256 cellar: :any_skip_relocation, ventura:       "d803af8c4ae43bb3c54ebc59517bd2c76a889d241aab9ad81beab98eee098ed6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "203d9e90dca47491c291d91b29de6dac25aa4a2bc20f3e22ed691631b57d9507"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "203d9e90dca47491c291d91b29de6dac25aa4a2bc20f3e22ed691631b57d9507"
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
