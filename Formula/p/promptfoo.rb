class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.100.2.tgz"
  sha256 "30f9027893fb6eeb9ce4f3e68c9786204237e81ace43fa9794122c39de646e35"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74356ff336fb50d6b1be41a5a12dda9ac128696c22c866a0b449a7f77df40b62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f79969fefa77ce4d414df4c796af48f4256ae0d30d01d7433fe10ab15418bd8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d8b4f346345d880e22f6ca2863f55ce7e21b7c2c692fa27910cb4ab9262611a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6ddf4a6d8f686fe5dcbe4f1a9f57f61469c2523865413fb0aaef58d321950d2"
    sha256 cellar: :any_skip_relocation, ventura:       "bf8d3637fbf05131a5c20e07c54244992c6b904066756656b833a53705aa8590"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f90f734830aa8a9806561bcf5c721ae94c6717b02cd2c4e36705cb86723cecc7"
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
