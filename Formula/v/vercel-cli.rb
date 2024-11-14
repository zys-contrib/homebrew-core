class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-39.0.1.tgz"
  sha256 "adbbadfb479b7c0303c470331afb4a0a64b362857220f1bc737e2d9b31930099"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46f6ef0e724889643cedb446cabc0b6cafb9d1f751811e3e2d9d87634533b1e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46f6ef0e724889643cedb446cabc0b6cafb9d1f751811e3e2d9d87634533b1e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "46f6ef0e724889643cedb446cabc0b6cafb9d1f751811e3e2d9d87634533b1e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "235aa65975e4a8f092bde6556824f96ebac70da9876d4f5eb5197304b53ad05d"
    sha256 cellar: :any_skip_relocation, ventura:       "235aa65975e4a8f092bde6556824f96ebac70da9876d4f5eb5197304b53ad05d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a634462b9eaed0accf95f18166fb4fb5375a8f8d8fa9f082103c47f5256195b"
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
