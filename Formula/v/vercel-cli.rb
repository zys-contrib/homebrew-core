class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-40.0.0.tgz"
  sha256 "f75137a0d2bc53aebfd823decd91b37340b6042ddb9c7ada63248cba82efd71a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "600c8afdf7bf04e12c7c1685e29f38ffb1ae26cf853dfcb62e8e0d210f31ef9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "600c8afdf7bf04e12c7c1685e29f38ffb1ae26cf853dfcb62e8e0d210f31ef9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "600c8afdf7bf04e12c7c1685e29f38ffb1ae26cf853dfcb62e8e0d210f31ef9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b9bb7a6fc2481a447481c9a3188557b1b45958e8cc708e5f2da3129ef8f3057"
    sha256 cellar: :any_skip_relocation, ventura:       "6b9bb7a6fc2481a447481c9a3188557b1b45958e8cc708e5f2da3129ef8f3057"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "182063c636e44c687b575f59f80cd6e8c74de128f896c49d8e7ec742561cabe0"
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
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end
