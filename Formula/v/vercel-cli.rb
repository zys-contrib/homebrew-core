class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-37.1.1.tgz"
  sha256 "716303316e3bf2ef57e9bb4ff91a97e67b08a763530b08305a2a0ea09b36ac52"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "04586262b679fabf02043aa261cbd7e2018609d02dc6b2f6026873704ed81c68"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04586262b679fabf02043aa261cbd7e2018609d02dc6b2f6026873704ed81c68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04586262b679fabf02043aa261cbd7e2018609d02dc6b2f6026873704ed81c68"
    sha256 cellar: :any_skip_relocation, sonoma:         "7e41acbb219400471b4940db59232ee9de31eb65e02841065c02d3845a0626ba"
    sha256 cellar: :any_skip_relocation, ventura:        "7e41acbb219400471b4940db59232ee9de31eb65e02841065c02d3845a0626ba"
    sha256 cellar: :any_skip_relocation, monterey:       "7e41acbb219400471b4940db59232ee9de31eb65e02841065c02d3845a0626ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed3a3a7774afbdbc63a6c8f03e2d4cad0d1404c1ffa538e9ae1050461d67cf43"
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
