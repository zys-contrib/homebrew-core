class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.103.5.tgz"
  sha256 "5cd9d254c7e66bd725f3bf4df8574307e0dbeacb27693ea6dd221e2fd1c60891"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2933b912abd791511138f80a0941b9b259e90c94b6113569d6966bb316427dbf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "160c7714137d22c386776b02a546e9eb37f313f99bc601605baf8f03cf8673f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "865c4e67d6726352882d978b15b1c79a81fae4b28266f51f094fcf2c1b4ed460"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7655075804d64fac38b89111ed4ab3b12c6d332a3f1d470c02e39e83384e52d"
    sha256 cellar: :any_skip_relocation, ventura:       "feee8be60ccee779c898b728e4ae9501d2498086537b9c746f7a166c2357093f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18c48a17039874e62d6668fec1491e9073877a0c477cead26e0fd6ffbc3205b6"
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
