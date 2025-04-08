class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.109.1.tgz"
  sha256 "01672ff046ea8734b085816f10acc538cbb66d22439310695442d0c71e89b644"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7f9eb773e4132d8be5735d4fa09dee129668651c4d6d7b0dff13316583ba191d"
    sha256 cellar: :any,                 arm64_sonoma:  "32339cd08bf54041c3a7335cfd55d9616fb982aa6be0203fbf4e97880ed25bc4"
    sha256 cellar: :any,                 arm64_ventura: "e8f2823180477fe7a8875d4520b86b2f83fdd3eef6ec7c475420b33b4efc10a1"
    sha256                               sonoma:        "0ce59adb103ae8f8e526557e645ce95420a1bbb946f1c9204a23fc77726cd416"
    sha256                               ventura:       "14b07b7f21a06b0c75f8158d69894c5500e6273093ee0990630547bb94f1eb85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33a4ead0d1eedcb2b743fc5204019bb29aa5681b153cd031822bf49cfc889ad1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3acb1e3eac859d3d606fbfad28f0c092a5b34cde6b8d9490fbb082d02e002bdf"
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
