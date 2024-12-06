class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.100.2.tgz"
  sha256 "30f9027893fb6eeb9ce4f3e68c9786204237e81ace43fa9794122c39de646e35"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02447e12cb64b9a9599139345a4a0cd150b9ba537562d264c24f71c95d28789d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99cd29cd63502b4a2060bd31a0ed235936e00ab0651caebf4439239fbdbf9ba6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1b4357921465cd73343abf5326619a3dc422aec92f1a6952aa0338cfb3bb0680"
    sha256 cellar: :any_skip_relocation, sonoma:        "ddd897f5c6cdf79393584bbccba79bb2f221bd7adb91e56ca33bc8e5402b0463"
    sha256 cellar: :any_skip_relocation, ventura:       "6112fbeecb2dfd758b408d0613dc64e77b40bb9e7f837a0854ad0f7ce45f33d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa9c48340fcba39daef5b6655bdb41c61f0638ab142930352ef7bdfee56637aa"
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
