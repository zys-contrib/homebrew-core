class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-37.6.2.tgz"
  sha256 "d89f092596941a65b7f16006c201f7b2fc1a94cfc401ccd2c9cbf7f0202f5bd5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8b7e186d096b106aed08e57fe7c6f509a19f723a390ab93c4522951c5670813"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8b7e186d096b106aed08e57fe7c6f509a19f723a390ab93c4522951c5670813"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e8b7e186d096b106aed08e57fe7c6f509a19f723a390ab93c4522951c5670813"
    sha256 cellar: :any_skip_relocation, sonoma:        "a111b85b8ad007c91fe9b05202ee53472f092d79c196258896a6b688fea3fd6f"
    sha256 cellar: :any_skip_relocation, ventura:       "a111b85b8ad007c91fe9b05202ee53472f092d79c196258896a6b688fea3fd6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcf5e91455812d60041ea7773bee0eff43d5282f111e0d43fee4837a40eb7d63"
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
