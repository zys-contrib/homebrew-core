class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-37.9.0.tgz"
  sha256 "5cb6be3ad99e14e33129c80812bcf57bf8430b006fbc1088d468c3aedfa25b21"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9de32289c262463d9979e4bdbd51f303dd0ba4153607c57a22cdb5b0e3edacd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9de32289c262463d9979e4bdbd51f303dd0ba4153607c57a22cdb5b0e3edacd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b9de32289c262463d9979e4bdbd51f303dd0ba4153607c57a22cdb5b0e3edacd"
    sha256 cellar: :any_skip_relocation, sonoma:        "075a645b271faa8a1085e73aaa16a3ccfda24879c0c4847f0ef7079c389cdc24"
    sha256 cellar: :any_skip_relocation, ventura:       "075a645b271faa8a1085e73aaa16a3ccfda24879c0c4847f0ef7079c389cdc24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae6bf1a884f6d00eee71ecaf9ff1857e28cccef5b83f5373e674e2e7c4482b59"
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
