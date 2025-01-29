class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-39.4.2.tgz"
  sha256 "1bef36667f5d309aef3b828a0f9b01ef98b4d9108c86c2954f658d76c59a70bf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12e4510ada79c51672cfedd7c2a564b94659507cc76aed9a25234340c44473ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12e4510ada79c51672cfedd7c2a564b94659507cc76aed9a25234340c44473ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "12e4510ada79c51672cfedd7c2a564b94659507cc76aed9a25234340c44473ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "022a9d8794df6f47e3edb4a868e203d7893e0d0dcae3fc5829a68a960486937b"
    sha256 cellar: :any_skip_relocation, ventura:       "022a9d8794df6f47e3edb4a868e203d7893e0d0dcae3fc5829a68a960486937b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21ca9e4894e157d3ba8eedba9c00f4c57e2cff23525f9263e3fded1dadc4c17c"
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
