class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.106.1.tgz"
  sha256 "e938299547151bf22b36f52d4b9efce94ff233dd7cdef9b023ee286f7054e943"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "067825fc419fd77250c98eced746ee620c16f6432003c8daa71c85ba312cfe09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "497852b0bf44c19f69dae49951fd3431b1d1b6228d5ff17257ee927a9aa8558f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "45e8ae99ec217b4a2b087ae6bd772e0c2ae48ae9edf1da64fbf0e9e8f4f2d153"
    sha256 cellar: :any_skip_relocation, sonoma:        "01f935dc7f9ddd6a6f255e177bd4550297c8978bf9303e77bddfd087f7bde447"
    sha256 cellar: :any_skip_relocation, ventura:       "981f5277a6ffcd9c9b35764d68e37eae881d1f46de9e7a09d8afffece2f9d5c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bc8cf3492cb346179fc34ad51f89a765494f4589ebe797bd0614718f68cb5bc"
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
