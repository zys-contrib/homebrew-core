class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"
  url "https://registry.npmjs.org/@openai/codex/-/codex-0.1.2504301751.tgz"
  sha256 "534efae4ced56e98b136a13bee4523acebf261267fecc11ea3df9a2854875186"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "902627d20eec97ccfea442b6ad5aba8b3be30b39620e248e444af2f3557e83e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "902627d20eec97ccfea442b6ad5aba8b3be30b39620e248e444af2f3557e83e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "902627d20eec97ccfea442b6ad5aba8b3be30b39620e248e444af2f3557e83e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b0bf800246962f876e5c30c65e36c8cd1aef87c62e62880957fbf5aba88bcec"
    sha256 cellar: :any_skip_relocation, ventura:       "4b0bf800246962f876e5c30c65e36c8cd1aef87c62e62880957fbf5aba88bcec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "902627d20eec97ccfea442b6ad5aba8b3be30b39620e248e444af2f3557e83e9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    generate_completions_from_executable(bin/"codex", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codex --version")

    assert_match "Missing openai API key", shell_output("#{bin}/codex brew 2>&1", 1)
  end
end
