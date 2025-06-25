class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-44.2.2.tgz"
  sha256 "fbccb7da7fb0d712bb78df8a93535f9778f254485b5a38509eb5c943fe1c447c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ab7978afc675ab9a81adb60711093d6b16c63a3beaa1cb070949fa1e43362b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ab7978afc675ab9a81adb60711093d6b16c63a3beaa1cb070949fa1e43362b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2ab7978afc675ab9a81adb60711093d6b16c63a3beaa1cb070949fa1e43362b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "c144e6f3df23944533fb2fe47026ee0d0a9163df3e5bc8f514433a15349af94b"
    sha256 cellar: :any_skip_relocation, ventura:       "c144e6f3df23944533fb2fe47026ee0d0a9163df3e5bc8f514433a15349af94b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60e2367da81824834aae44a8559989670337c248d48a85ac78be1b20ec93b2f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b46def26ae993132baef661e1e48d601e69bc26c1e9398e5f6b5b5caa7ebe356"
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
