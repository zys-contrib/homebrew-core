class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.1.4.tgz"
  sha256 "400eb9b5cb8ec71c8a391444b5412882001d7fa3aedff3911ad0f8145110fca0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc9cd3d3b48ff2936eef5fad4361ab41659873da9d2b1f03f06bd604d8e85b02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc9cd3d3b48ff2936eef5fad4361ab41659873da9d2b1f03f06bd604d8e85b02"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bc9cd3d3b48ff2936eef5fad4361ab41659873da9d2b1f03f06bd604d8e85b02"
    sha256 cellar: :any_skip_relocation, sonoma:        "d847e1e47173da79fd069d007e15ac3a10e1107cbc53135e38588e44c6d8e22d"
    sha256 cellar: :any_skip_relocation, ventura:       "d847e1e47173da79fd069d007e15ac3a10e1107cbc53135e38588e44c6d8e22d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc9cd3d3b48ff2936eef5fad4361ab41659873da9d2b1f03f06bd604d8e85b02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc9cd3d3b48ff2936eef5fad4361ab41659873da9d2b1f03f06bd604d8e85b02"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gemini --version")

    assert_match "Please set an Auth method", shell_output("#{bin}/gemini --prompt Homebrew 2>&1", 1)
  end
end
