class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-44.2.0.tgz"
  sha256 "22e493701ca95d406934feef1ccdf8c54d7aec15576ef9b3b860ecd1dc95450e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fb7438939a732efc31edf8f2cfbe7190034026e4497be074fcfffca3f42e68a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fb7438939a732efc31edf8f2cfbe7190034026e4497be074fcfffca3f42e68a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6fb7438939a732efc31edf8f2cfbe7190034026e4497be074fcfffca3f42e68a"
    sha256 cellar: :any_skip_relocation, sonoma:        "44ca38cc9082444ff5e1d6a6b62254e153037017831a39e5d97e010437806154"
    sha256 cellar: :any_skip_relocation, ventura:       "44ca38cc9082444ff5e1d6a6b62254e153037017831a39e5d97e010437806154"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13177102bb80d884b400521753352a6e9b57f57b4fe8bc097cf7a423f1860679"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0fb25c1faf693cc3916153887d669e34785cdc61d05d35e876328d7e7c5a9f5"
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
