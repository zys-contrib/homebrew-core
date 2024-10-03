class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-37.6.1.tgz"
  sha256 "b62b3f9c423cd3d9c9733045ce3617d4674517aa4c445a0f7b6886205a49034b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "262619a6f3049f7ea756ab7807144c2040a56644748f3eb458873b8a196bdf0f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "262619a6f3049f7ea756ab7807144c2040a56644748f3eb458873b8a196bdf0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "262619a6f3049f7ea756ab7807144c2040a56644748f3eb458873b8a196bdf0f"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd33213db121432cdd342dfaba8089fc603f407a67804b50fefc398f9700e966"
    sha256 cellar: :any_skip_relocation, ventura:       "bd33213db121432cdd342dfaba8089fc603f407a67804b50fefc398f9700e966"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b09b0bc663e435de5161a6750e771ac39ec69d8ec48af3d1093a6fcde3a49c9d"
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
