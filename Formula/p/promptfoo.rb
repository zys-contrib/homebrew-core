require "language/node"

class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.73.5.tgz"
  sha256 "9f421fb8706661942dfcc2dcde34f4e8d2504d8f4c6f1fba485838a9aba71d00"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "52b385b1ee40f3b6f4bbaad2b33a28070eecd1c478333ebe89082c4d8121cdbe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2338202ccac43f38a7498535e63dc99b0252c7a3664560e17e758813622f8dd7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "209463b5812175d58a79003d231c508bbec745803ef27d3e7844618472dd554b"
    sha256 cellar: :any_skip_relocation, sonoma:         "4f1b1f56b23eab844df0becd591b8e965fce2f73b2ef10e405277094b77844ad"
    sha256 cellar: :any_skip_relocation, ventura:        "7fd2c0003264589d861168d3726e06cab3da2ffc0828adbb0c65bb0c4f5a1940"
    sha256 cellar: :any_skip_relocation, monterey:       "529f0dc3e8fc82f64ee7332165e63de01af3e22f93c4a9b5317fba1333c08d07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d4181d8585ddd2cbfc21b3ab3e10c7afa12780aeb41cd73d442de06a387af92"
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
    assert_match "description: \"My eval\"", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end
