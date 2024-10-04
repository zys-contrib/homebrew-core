class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.91.2.tgz"
  sha256 "2a5bc6cd1f862c3dbbede946d95a9480d3934de5a223c09b92fa10821b5c95b3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86f529560a290d910a0160d41f29631f4a7d400e647c70588b34881aff189021"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d91ddc9d3c6d8d9dd7b495b23476ef6b41e677e3659bdd2d72c4a132e1ded6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "083a47672e6dbcc81f16daa6a960dc5fbb22ca2ab8b59da4aef137a053dd8b00"
    sha256 cellar: :any_skip_relocation, sonoma:        "02c306bcbc53309f523861acef124ef5add9ddd632e898cbaf8b1796cbabfc0d"
    sha256 cellar: :any_skip_relocation, ventura:       "054c94091eacd6f2a2f85b7932982ad1b493098a71e87a43f6021fc8974b5499"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23dce415b35be3923e348d1cf96fb042fac0b3da437281de9459e4ab876ace78"
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
