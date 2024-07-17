require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-35.0.2.tgz"
  sha256 "c040f00615a7720d48ffc48a90f42eeaa434c47d3768d30f9a8af54b8f97cc5e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "04dcf8f9ef598ed94a97544cb6e9d4682524c41711fbfcfabb75b1728ed0d4c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04dcf8f9ef598ed94a97544cb6e9d4682524c41711fbfcfabb75b1728ed0d4c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04dcf8f9ef598ed94a97544cb6e9d4682524c41711fbfcfabb75b1728ed0d4c1"
    sha256 cellar: :any_skip_relocation, sonoma:         "0a4ec60b94c075347c4ae926782196f1a6e8b43b092d8065a005669a186bbca0"
    sha256 cellar: :any_skip_relocation, ventura:        "0a4ec60b94c075347c4ae926782196f1a6e8b43b092d8065a005669a186bbca0"
    sha256 cellar: :any_skip_relocation, monterey:       "7895be7d8da73e0d0e92d2e296630c90f4e44a0f94d105f7d26223b98bd9073f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d69040a0bf4e79d9826d77bcdd8da9c8727d31390cde431c97794d8c3c17aff1"
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
