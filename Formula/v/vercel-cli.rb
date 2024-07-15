require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-34.4.0.tgz"
  sha256 "d70fd5689a5f32bb597c25e09fdfce168841eebbf1ea3adaf7f9319a558a3f56"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cbee643e8d96ed372287f81b61f11e721cd8c0c3d8f1e3c5fbef4d2daf6f5184"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cbee643e8d96ed372287f81b61f11e721cd8c0c3d8f1e3c5fbef4d2daf6f5184"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbee643e8d96ed372287f81b61f11e721cd8c0c3d8f1e3c5fbef4d2daf6f5184"
    sha256 cellar: :any_skip_relocation, sonoma:         "f2ba62e93727bdc9000ae85d754a6bf13f31bf44bd7cb45fa30c56962b259aee"
    sha256 cellar: :any_skip_relocation, ventura:        "f2ba62e93727bdc9000ae85d754a6bf13f31bf44bd7cb45fa30c56962b259aee"
    sha256 cellar: :any_skip_relocation, monterey:       "f2ba62e93727bdc9000ae85d754a6bf13f31bf44bd7cb45fa30c56962b259aee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "baf915810e6ec70637aaa38263ed2ba627c2af16656280307dd5d2d1950b94cd"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end
