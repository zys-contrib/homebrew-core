require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-35.0.2.tgz"
  sha256 "c040f00615a7720d48ffc48a90f42eeaa434c47d3768d30f9a8af54b8f97cc5e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b1838964cb1cbd6cfee8c6c5e2b9daa5c63a3cf54c9b91a0348b1d7d8c6cfc1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1838964cb1cbd6cfee8c6c5e2b9daa5c63a3cf54c9b91a0348b1d7d8c6cfc1a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1838964cb1cbd6cfee8c6c5e2b9daa5c63a3cf54c9b91a0348b1d7d8c6cfc1a"
    sha256 cellar: :any_skip_relocation, sonoma:         "4fe49e93cc4584b4cb90cbd33b42a3ca6a4233e6d27e4228726e7327b8f08403"
    sha256 cellar: :any_skip_relocation, ventura:        "4fe49e93cc4584b4cb90cbd33b42a3ca6a4233e6d27e4228726e7327b8f08403"
    sha256 cellar: :any_skip_relocation, monterey:       "4fe49e93cc4584b4cb90cbd33b42a3ca6a4233e6d27e4228726e7327b8f08403"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67c87e832d3c125e565d70eefb892095ec90f785f30827ff12836e4b1bb1c58c"
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
