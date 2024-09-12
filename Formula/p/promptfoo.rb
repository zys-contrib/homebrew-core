class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.87.0.tgz"
  sha256 "06bec462e1bcd2bf47333dd7e631d5215a544cdf32dcd8ca1c23538b9129208a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7743a38d9924b2db168c044e8e1ff977718d184adef105ee00f96c2a04eadc65"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca7d5fd57c380fd0cbd8625d4dba80b34f85664231e35e1f08b0d04721f806d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f322f5662157f083ddbe917b2d85026539b426c5ac3d0fed5aa39e1bfc0aeea0"
    sha256 cellar: :any_skip_relocation, sonoma:         "27e9bcb74b3567b301f1b2e88e177a792a2df327e0811debd09d0003bd7ed39e"
    sha256 cellar: :any_skip_relocation, ventura:        "56f9d3cd35bb34f43cfb2305c509bc27c45992942027b6bb228cf6f55ddd7aa4"
    sha256 cellar: :any_skip_relocation, monterey:       "0d246ab869f0b3f1dc5fb5286d9a9ebf261379d45e9c00e970a006177f86f7a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb7c61e116a4f47433ccd88893e626e29cbefc3c3fe2c3c7ec9d8c1070e6c3b1"
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
