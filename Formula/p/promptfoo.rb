class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.114.4.tgz"
  sha256 "9f1361dd2af0239e43a6fb542e1fd3111febfff4808d8834261e92c15a9ee69e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "014a6da4698269a0016798f1842e2469a9e7777c04740418849cb5ce66f21550"
    sha256 cellar: :any,                 arm64_sonoma:  "05db6c8f8133fe11e022f20835c51e0b4a2d71b0a8b5e6db62d78dd75a251ee5"
    sha256 cellar: :any,                 arm64_ventura: "1503b366218826a6ac9fde2a149122ae9ad47cabc20adf93a658047794e665b6"
    sha256                               sonoma:        "816025a787c050e487a9e86ecc7a7adc9f848dd8ed5f7173551c22326c26f44b"
    sha256                               ventura:       "0701d0b757b2a87bed3b74a8bb4a72c99c8dc4cbd666918d1e50dc43fa7c1947"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7904b7f2d9f5e63586001822c50d42ea189b2d42780dd76dc9b5215b78da0266"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f9c37de2a05fea95a7f1aba01b8fbf8de4ec1f7aa26bfa9babdbad50df157cf"
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
