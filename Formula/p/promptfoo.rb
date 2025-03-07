class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.106.2.tgz"
  sha256 "969068ea8a6e4ac200dd6a72502cfecd72082704de026849ed621f4c9abcfd4f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0912169e6ff5a562e7326cd47fa49fe2ea31d990f79df9d7d49169e6f6fb7592"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea03ad2c08baaff21877edf28450b9d50e506979f4220917c50ce8c93d04c42a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "16b824f848cde6f0f19ea104182959508106cc50fba84de51a06722f87edc3a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "713c31a125e4aeda067fdbec1d220e79e8b300d20964d22e66528218cbdc7b7d"
    sha256 cellar: :any_skip_relocation, ventura:       "791266371299e22a49dbfa15efbb6a2aa26e25a197001f9034b441ce9c28bc72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26f2216b748f618c209850e877c14b9dcc05ea7bd73354fc9bc4a438b179e277"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_path_exists testpath/"promptfooconfig.yaml"
    assert_match "description: \"My eval\"", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end
