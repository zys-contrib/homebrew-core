class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"
  url "https://registry.npmjs.org/@openai/codex/-/codex-0.1.2505140839.tgz"
  sha256 "aa826f3dd43329a4515a04327f6ee7957477219a8d73d7277c5c87d937545168"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47a4e440e02585051e997ed1537a2e4a754d1b40fc184f732ba15187fd635fa4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47a4e440e02585051e997ed1537a2e4a754d1b40fc184f732ba15187fd635fa4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "47a4e440e02585051e997ed1537a2e4a754d1b40fc184f732ba15187fd635fa4"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c9fed3d5b49c4844a88152fc541b42fd5abc0c4303aaf7ed4a9070c1966cb4d"
    sha256 cellar: :any_skip_relocation, ventura:       "7c9fed3d5b49c4844a88152fc541b42fd5abc0c4303aaf7ed4a9070c1966cb4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47a4e440e02585051e997ed1537a2e4a754d1b40fc184f732ba15187fd635fa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47a4e440e02585051e997ed1537a2e4a754d1b40fc184f732ba15187fd635fa4"
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
    assert_match version.to_s, shell_output("#{bin}/codex --version")

    assert_match "Missing openai API key", shell_output("#{bin}/codex brew 2>&1", 1)
  end
end
