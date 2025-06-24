class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.115.3.tgz"
  sha256 "ec184b8814c7ef0838bebbc2d9c89308d54647911994b47d4f3c3df89b471c71"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "63700e4c8ae085cf8874212b4fcf056971abcaf81305163843e311b45b03977c"
    sha256 cellar: :any,                 arm64_sonoma:  "be60b3e968d203270edd1d79f35189acc8be11390125618212300b24bf5ed7ba"
    sha256 cellar: :any,                 arm64_ventura: "aa857d27f46b8cefcb998c409f234bcdc17f866608179cbca2773605fa59b712"
    sha256                               sonoma:        "d5fd15840adef2c42a6c5c068f86d963b14e820963db79c26c0f5ed182310f06"
    sha256                               ventura:       "04686f6b557876afc80814f9dc43d698b7d5e18c6e590a396d29fbc4ddc478e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d45b6f3834c27e296561d453242c597c73c5d7f54b5ee5dbfdc043860a72d56b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cd6d6493e2747619ec33473a934bfb421d6c12de53fd4452e72648413f57898"
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
