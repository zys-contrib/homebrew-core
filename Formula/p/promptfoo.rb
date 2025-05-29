class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.114.2.tgz"
  sha256 "e8705093ff4810c9a2f3316e10e6ee6c6b7cc066d94f07e69a074ee20173cf62"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2e0867423df931dd8295e2af972447a57427bcfdb34fd393bc9ed8851c51a0f6"
    sha256 cellar: :any,                 arm64_sonoma:  "5525ce60fbb9d9719c4ecd1ddffb33c684d262972c98cc52a2fd50c1f2e3d162"
    sha256 cellar: :any,                 arm64_ventura: "d841467d8f8b3a62f0c74830c4d551a9d38927707360c4e40fc8c59eb3d4f800"
    sha256                               sonoma:        "7aad5f0a18f4d22646cc9e1691ee652bb7fb60e3c9e159150c9ce28eb65f4f7f"
    sha256                               ventura:       "4fe6019c100bccb6653d09550e67c86a1974f6b2e4ff409bee2d44d7a8502003"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24e9574306743515e09ad8d02464e59e9cadaf604fbbcffba5e8516c6037ccd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3fb5f65617b8bb2bace74887c8ffcdf52497bf7ae3a6e350c4093849785362c"
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
