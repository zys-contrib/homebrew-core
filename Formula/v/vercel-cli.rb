class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-44.2.9.tgz"
  sha256 "baa19e9ba0928de59da87f73a0690eed460f7b94cfcbd0ba3ca22b15b2feab6c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1b53adc381eeea0ae5530c60f9b12955e8f630cd526308fd229d95d96189700"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1b53adc381eeea0ae5530c60f9b12955e8f630cd526308fd229d95d96189700"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d1b53adc381eeea0ae5530c60f9b12955e8f630cd526308fd229d95d96189700"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ee335c0c3bf141cfe1de2ca6275a597bb9d08705b9280d2041c611b4ad81c6e"
    sha256 cellar: :any_skip_relocation, ventura:       "0ee335c0c3bf141cfe1de2ca6275a597bb9d08705b9280d2041c611b4ad81c6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3042b98fa418bad080634cfe6a58a2355f99f9f0e599a58599e2e8b83d0d586"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c8909cb7d04489a69e6ac999eadc2f5846d8f6168fe65c357487e440380691d"
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
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end
