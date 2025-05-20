class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.112.8.tgz"
  sha256 "41a7e5e5038de10507e03e721326d5eb086e0fe44e58b754e6e7715535c0f49a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5cae8e194241dc308e52d6ecb29a4310f854403ff7d746a733626cddd37ec554"
    sha256 cellar: :any,                 arm64_sonoma:  "f23db46c6837b12ee434af348df31f886a87682dbc608e1999420a62dcfa75e1"
    sha256 cellar: :any,                 arm64_ventura: "13ae94c2638769f1ec7503ca00e5ad4d3cad45f963acfa38edd6608518ba89b2"
    sha256                               sonoma:        "8f976452613fe6a29cc5cd116c43d7aaf71860e44c015b599c2722785318c870"
    sha256                               ventura:       "52859ba61351cdeee31408fad6b367b9efd4cadeba21547d5e533cf0e619d6bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36c7a74a9765af9d745906f0be7cc6035623f1f19f90f8dbd4ac180b3d9a67b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e42f65d80670c36e472f37130ec4e0916e749b3e065c3df59840710f6ea2d12"
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
