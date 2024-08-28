class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-37.2.1.tgz"
  sha256 "8677054064173385009708b24d306f74ff5f01871893392ad79a9b42515a95c4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "44dfbd52bbc5fb75ab79f84ca300ccf1c8a82e9604659982b6528715c16fad3d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44dfbd52bbc5fb75ab79f84ca300ccf1c8a82e9604659982b6528715c16fad3d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44dfbd52bbc5fb75ab79f84ca300ccf1c8a82e9604659982b6528715c16fad3d"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe2b77f98d75b7660fd093ea89caf4d48b29416986275372279433ba2e54a9fc"
    sha256 cellar: :any_skip_relocation, ventura:        "fe2b77f98d75b7660fd093ea89caf4d48b29416986275372279433ba2e54a9fc"
    sha256 cellar: :any_skip_relocation, monterey:       "fe2b77f98d75b7660fd093ea89caf4d48b29416986275372279433ba2e54a9fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "961178ae3c9f5b903e680a6a7bad1a14746d2ab36f8f9a272502a117279d0f76"
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
