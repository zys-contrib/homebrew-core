class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.80.1.tgz"
  sha256 "6564b4b7b45b3989194e3ae70af5ed92aad1d42caeaf6b1dd64519119145ea0f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3f8d8d8e45f0ef4ffbe5d8c3b439987f6f742385ff68fd06d2d0f993c6526733"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "451ca416021b8773c12a5907c194d3bbba933c794a1c7a65f42506806e0bdf4d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f7cafce04f41c4536d0b5e8023869d6bb734437fb5f6abc166d0f6b6faf4bb4"
    sha256 cellar: :any_skip_relocation, sonoma:         "38464540ee53fce8976fb12bfe666efac983f4200af6755ae6e20ad2c7e5fd2d"
    sha256 cellar: :any_skip_relocation, ventura:        "889b86b5f819621ac4114a029c8d86cd2cebed08fb8f041b3b6393789247f818"
    sha256 cellar: :any_skip_relocation, monterey:       "d262bc6ec184824d7e009615ffc51a18ab9b01f6d40bf360adfb4b4f3f77ac7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a62536a751df4649f3a265eb5dcecd9a748383262a518a3fc4eaf0b64f4b866d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_predicate testpath/"promptfooconfig.yaml", :exist?
    assert_match "description: \"My eval\"", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end
