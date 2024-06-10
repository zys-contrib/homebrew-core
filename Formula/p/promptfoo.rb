require "language/node"

class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.63.1.tgz"
  sha256 "8f8f144ef218f4e2ad25bd1de40845b0c7fba07236b170ccbd3a87cb970a4a4a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "412a367c840c38d0a78b9218e694bd9dba694fd2ab0f081858b3c1ef4cc8907c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b18fac8194a2aee9201292abbba22a3fbfc977f75b521590781fb73d44d9a50"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c6671a3e9c8ea0139f50eff73bb27af9be0bbdf5fc0b7390aba7ebfd1551662"
    sha256 cellar: :any_skip_relocation, sonoma:         "a62ebf77f83009e22b77262fdcc2f651870c052a6e088fcd17f09353673280b8"
    sha256 cellar: :any_skip_relocation, ventura:        "91a2a168ae9e2001f509e1304c5484d3391e3770457b913d2e80d04603895e5f"
    sha256 cellar: :any_skip_relocation, monterey:       "f0bbbb2931f741542fe12e2e115ce429851e988c81b7756b29647a0b92527147"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1dd0228a83a95a95b270a47a1b4abdebe443d5584b1805431ea6a8828d5af522"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_predicate testpath/"promptfooconfig.yaml", :exist?
    assert_match "description: 'My eval'", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version", 1)
  end
end
