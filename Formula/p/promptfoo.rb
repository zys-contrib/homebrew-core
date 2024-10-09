class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.92.2.tgz"
  sha256 "e9da00c4c21377191dea80645226387a8470ee4b092cb31d25c8d07f1109fb17"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e407f206d29bb54638c402471f8bacb7e271352c83526dd7a5677df261abc1e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8ced4887ad3d3511aab9e4d37968c66eb99670532a1eaa59c37ddacc77d7f39"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3a9ed39710973396ff25ff721f62ab4e7c6c1f596d7ae968caaa9db3f2ffeee2"
    sha256 cellar: :any_skip_relocation, sonoma:        "58d953ab80201bc85b937c45d01cfe61f812e513d39f3c27c07a39a9501ac254"
    sha256 cellar: :any_skip_relocation, ventura:       "ad55108579962e03a387ffc9dc918866d54d1954e6a7dfe4d38da8ceaf5722e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10d22b27f6efd9394de55907f1c9ec898d3550243efb783e017568da214ea666"
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
