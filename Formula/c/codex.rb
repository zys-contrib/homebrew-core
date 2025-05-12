class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"
  url "https://registry.npmjs.org/@openai/codex/-/codex-0.1.2505111730.tgz"
  sha256 "87fe060703384b92745904d6fb94c3763877af8173c9f0b796458cc8b8a2ca65"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85df5edd03aa3806252b9868d83ca32cba01d252889970f77bbc020c37933d9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85df5edd03aa3806252b9868d83ca32cba01d252889970f77bbc020c37933d9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "85df5edd03aa3806252b9868d83ca32cba01d252889970f77bbc020c37933d9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c0511f07c5d8b0ee0d5bd810f802fafe569a9b002590afa8e2452bdced54c37"
    sha256 cellar: :any_skip_relocation, ventura:       "9c0511f07c5d8b0ee0d5bd810f802fafe569a9b002590afa8e2452bdced54c37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85df5edd03aa3806252b9868d83ca32cba01d252889970f77bbc020c37933d9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85df5edd03aa3806252b9868d83ca32cba01d252889970f77bbc020c37933d9d"
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
