class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.82.0.tgz"
  sha256 "cdec47886a79c27ded1f5ba752d14e9d741676ec748e99ba35622a92aacbd5ff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ffcd8c28eb306a48dcb5159e63961d613153aa9883b95b8d3c24b00b3d6eb756"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "46c78e5ac6523562bc42fa140929f9003383117d6ed4a8ec209338c1a617e651"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32e9397abfaf6fa315fba182ad759a4f6b66b9709ee5fbf4e2e2d2eb743ff211"
    sha256 cellar: :any_skip_relocation, sonoma:         "5c07e0e44c2921eed21c6021a7ba496356535698304d183fae72e32a5a839dda"
    sha256 cellar: :any_skip_relocation, ventura:        "a169ca6541ecaeb733f91b2c3b8a0843a1898ef21d937fd509d448b7f0fb18aa"
    sha256 cellar: :any_skip_relocation, monterey:       "4eed5682b932d25dba5fc98ddc41cb8f99d761faff791a182882913d93ea3c00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "462b32cdd6cba74f84b6ee8ad02d1e1270dbdc61c47f0cd9a3839891bf3d22d6"
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
