class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-35.2.2.tgz"
  sha256 "af489b595daeac99f04baab1bfe24dca9d4c103391ac9d6ab9671ac77f0135a6"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2426462a8f53824a133f952b8068e075b3052847d1804fa86d46314f342bdeaf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2426462a8f53824a133f952b8068e075b3052847d1804fa86d46314f342bdeaf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2426462a8f53824a133f952b8068e075b3052847d1804fa86d46314f342bdeaf"
    sha256 cellar: :any_skip_relocation, sonoma:         "0343f517d797dfe316db6972af20f38b3208c17e47f66494a3b5a2615b911a1a"
    sha256 cellar: :any_skip_relocation, ventura:        "0343f517d797dfe316db6972af20f38b3208c17e47f66494a3b5a2615b911a1a"
    sha256 cellar: :any_skip_relocation, monterey:       "0343f517d797dfe316db6972af20f38b3208c17e47f66494a3b5a2615b911a1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "697908a7a866b83719e63238e1323bb01734ecc249431ce76864825f9196a8eb"
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
