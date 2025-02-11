class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-41.1.0.tgz"
  sha256 "b9d3fb60bf9f1675ce706a0f8a79162c8ca0bbb09d9d1c512a52518c06b23c0f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57365f47581305e898e4402c623a41d0dcc99863e8b43ab72e32ffd2501e45a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57365f47581305e898e4402c623a41d0dcc99863e8b43ab72e32ffd2501e45a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "57365f47581305e898e4402c623a41d0dcc99863e8b43ab72e32ffd2501e45a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "19f01194fb01da348e6e70e82c8a7de6857c0eb9f7d11dd3f5dac4d95ae043ad"
    sha256 cellar: :any_skip_relocation, ventura:       "19f01194fb01da348e6e70e82c8a7de6857c0eb9f7d11dd3f5dac4d95ae043ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "546bfac2e2b147e080578574da361f6918e0076b87c6c79d890cd50461a3d7d1"
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
