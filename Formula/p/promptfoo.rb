class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.102.4.tgz"
  sha256 "493002f5040687f4257311ff0f5faeb6c5b53e4b6488bed97da475ead27bf4d4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6ec610d00450e0f1642d69e0f321086f802eaa79cc180726980053f4901ac04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c27763c1854155441f54ac650b6fb040963f9f68f4ce2380a5cb57b58e7c34dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c94ce2e978c553e0d8deb129ab75ed13296994e32e75d789b50276be1843847f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b596f4180ef08b5d5641bb7949b3c2daad2666771950633f9d461005560d5f7b"
    sha256 cellar: :any_skip_relocation, ventura:       "10bf107c538e1fb0971d3bab2f0e21f5fdf75272a194d90348021c4d65cfed8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7579185eb3a50204ee9a7e180c54058a062ee3de9e2908883cfe37303b9c5a0"
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
