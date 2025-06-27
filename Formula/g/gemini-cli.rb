class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.1.6.tgz"
  sha256 "71af3ab422d5a61bdf260cb01778cf9179c796ed8d95fa3e085b0047e4efee7b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "452487e41dd392a35c865b416acb6d2fd09a4f2eae9cf4c4051aa630783cd7a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "452487e41dd392a35c865b416acb6d2fd09a4f2eae9cf4c4051aa630783cd7a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "452487e41dd392a35c865b416acb6d2fd09a4f2eae9cf4c4051aa630783cd7a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "240a8b58728a00018c5192f7a036c09e791fd750792cfb72792acd46690b0675"
    sha256 cellar: :any_skip_relocation, ventura:       "240a8b58728a00018c5192f7a036c09e791fd750792cfb72792acd46690b0675"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "452487e41dd392a35c865b416acb6d2fd09a4f2eae9cf4c4051aa630783cd7a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "452487e41dd392a35c865b416acb6d2fd09a4f2eae9cf4c4051aa630783cd7a3"
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
