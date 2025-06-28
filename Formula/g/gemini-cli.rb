class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.1.7.tgz"
  sha256 "7d960ff5f7332149419fd32cf483f30def1c7fe9b9ffee490b98957b8e04df32"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a68e585e4a6a352d13f6677b6a8b7b48dd5afb102cb075cd1ed52e71010584a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a68e585e4a6a352d13f6677b6a8b7b48dd5afb102cb075cd1ed52e71010584a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a68e585e4a6a352d13f6677b6a8b7b48dd5afb102cb075cd1ed52e71010584a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "29972b7aa6799c97e3facba67990df19b5f6c964c899ce469b4249968c6182f8"
    sha256 cellar: :any_skip_relocation, ventura:       "29972b7aa6799c97e3facba67990df19b5f6c964c899ce469b4249968c6182f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a68e585e4a6a352d13f6677b6a8b7b48dd5afb102cb075cd1ed52e71010584a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a68e585e4a6a352d13f6677b6a8b7b48dd5afb102cb075cd1ed52e71010584a8"
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
