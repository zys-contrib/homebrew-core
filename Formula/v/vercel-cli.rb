class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-42.1.0.tgz"
  sha256 "790a6981f3149f88e86d67c3407250f23900f1cda117d5f2350da8d55bdff332"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ed7eb5c2cc012cff5cf508f9c06f4e2498eadf5162821587f318664f1980d9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ed7eb5c2cc012cff5cf508f9c06f4e2498eadf5162821587f318664f1980d9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9ed7eb5c2cc012cff5cf508f9c06f4e2498eadf5162821587f318664f1980d9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f55bdf36d5a9316a21a6c26203ba394138a9022131a574d131c7e16fb8092ba3"
    sha256 cellar: :any_skip_relocation, ventura:       "f55bdf36d5a9316a21a6c26203ba394138a9022131a574d131c7e16fb8092ba3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbab802bd98b8db97cb8d02d177cf13e1ec96cd59bb7219f8869ddb13d2a2112"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb924575fc64ec8d7684f24a8c1177cba87240f8079deba17e98131a05c0803e"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end
