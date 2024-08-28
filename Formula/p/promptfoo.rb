class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.81.2.tgz"
  sha256 "124da9e10243d8d0c53376b7c4fb90ffa03f4028c26284747c02cee1ec3713a6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "30df0475ae92f0dd9f05df49e8b764ad8a1bf8cf627bf48b5d235994b9f5c182"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a6a015012d0854f5ce20db07a68b9f232831bdc5ee73542dfd9b4979767c233"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c80f33940a0f8b5028d895434969d92d5f48d342f9fff4a16f01e8d24c01f5f"
    sha256 cellar: :any_skip_relocation, sonoma:         "b33bb96c4da710db20cdb970043a98374984c141c4918bc4ffe993fe3e5038c4"
    sha256 cellar: :any_skip_relocation, ventura:        "2f5fd7ef1228446478e3a43e7b1a2951c437e227148db918ab1442f50df4008d"
    sha256 cellar: :any_skip_relocation, monterey:       "ce6e00f70d123ba92ff9e62b6edeb641a0d4b5cc0812cea029ec398f5464a44e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00c29667b1aea24bed169acb2c237328050b0c5d566e1c2cee3802d73904225e"
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
