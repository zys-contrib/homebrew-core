class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-39.0.0.tgz"
  sha256 "86ed026a218d47f37df17afe2d35f170177f5005ce65beeec29d617d6dc54a1a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f92767859588dffeae1259e7307427cc87e3734bc576b6190dc41230c899a5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f92767859588dffeae1259e7307427cc87e3734bc576b6190dc41230c899a5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9f92767859588dffeae1259e7307427cc87e3734bc576b6190dc41230c899a5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f699cb4c2c35dd26c4bebd9cf2db04fd1e87b0fe58933ddb7539b8933d9d0f93"
    sha256 cellar: :any_skip_relocation, ventura:       "f699cb4c2c35dd26c4bebd9cf2db04fd1e87b0fe58933ddb7539b8933d9d0f93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "929f922f06ae773608d11040fbd8565ce18bc85a57216f13060bd767b8d06435"
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
