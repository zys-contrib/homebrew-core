class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.103.12.tgz"
  sha256 "4166c293ff600eb54f56e2abc646abe81e74bb5245b69b10ca31b2e4d128868f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3fb17bdda5b6f3da2fdef1dc1c67e1183c0e13e62472cad92afb5e53cf9c9ef2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "676015c601f622320db8808db9e1f7e66badee14fa723b6e6128b8194d7c0c60"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1160df0c14918f4c706861ad2e1f5ed66f6b8c7736f1d4ef0bde54c2cc4e55d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e46e073e4fb7128f0c10514651c7a391d868be50c1c76dade7a974a96f2c7e5"
    sha256 cellar: :any_skip_relocation, ventura:       "22259d64f291e564cbc8bbf1850253be4564bf5ab1e14c15169eb305f57361c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "147fe993bea36bbf70dc5d093dd55a07972e861e9c662aa13f9c0dabe2b8566d"
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
