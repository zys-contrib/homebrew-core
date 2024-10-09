class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-37.7.1.tgz"
  sha256 "d483e2d6ae5ad4b512d3b9368f95d721a332ef9d5bb331c7dc8d2b3696b02897"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca79d95bab7462aa58ef0eddaaf25f4fee67690b822cea58cafe33a229c51368"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca79d95bab7462aa58ef0eddaaf25f4fee67690b822cea58cafe33a229c51368"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ca79d95bab7462aa58ef0eddaaf25f4fee67690b822cea58cafe33a229c51368"
    sha256 cellar: :any_skip_relocation, sonoma:        "1bd49068c760141bd346a8bf14f8229175850b49d3d589981d221129e61d911f"
    sha256 cellar: :any_skip_relocation, ventura:       "1bd49068c760141bd346a8bf14f8229175850b49d3d589981d221129e61d911f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0052223c4c5093cb0ce3b4f2481164d9e25db1ac2fdb22edef2cbeea41328401"
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
