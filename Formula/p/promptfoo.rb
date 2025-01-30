class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.103.17.tgz"
  sha256 "1f10758ea3164fd1aa1c36ce4aa894238473f7623cdae1036f54baf1d31e861b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9e0c23ff8067c9328ac9f8fdbdf1943f1664b4a9c51ac3aaa7baca0e133eb98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "715572637ed885436b02aedbd8577b6b591f0d5018333cab46bbb32ecc885217"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0a438f19c1fbedf48e8b76e452671863ebabb6e2f07c3a89db241e189b0edce6"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b7f71bba4f6fa43fa33d4eb4d561542a691d8e8eb8991e21c38a6207edf18d4"
    sha256 cellar: :any_skip_relocation, ventura:       "1d33ef41276f8c1631dc1ab4c87e89d85ca01df531e3aee6fb361db48c7373e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3f666233849982bea30e3380456a7166b3aea66b6ab83656e1739d7f1dc8243"
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
