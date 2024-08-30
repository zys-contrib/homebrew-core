class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.81.5.tgz"
  sha256 "b48f201424619bd140bac0bb5cf16ce3e249e8b06bfcdbae32d6b44e9f170333"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5525c9f867bdf520a08b176087615488f83ee2461d73e1cc6e2ecc93b836a1a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4b23abfdc055c83f284d252637b8ae791dd842222a1693e0fd83012adba4133"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1af0236d365378becb15924154def5c8e13568cdac94779983d02e29d322b463"
    sha256 cellar: :any_skip_relocation, sonoma:         "681cb328092585874b2d5539f0bd9bb943f79550850dc6f311e639f1c699d907"
    sha256 cellar: :any_skip_relocation, ventura:        "89254fddd091ebf7afd71448419148e9958e1f34ac7dd9edd52ac4aae1aa52f2"
    sha256 cellar: :any_skip_relocation, monterey:       "8efd896b9c4d5dfe9f7906a4439e9074fe96330912dd1977e6e054167f7351a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49e123b9ca0a80f1be3788b55560253f56e48bfda19be7af080370ff57ddf0e3"
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
