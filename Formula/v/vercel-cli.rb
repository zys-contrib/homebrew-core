class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-39.0.4.tgz"
  sha256 "3966934c411d605efd54d7ce3f0a8c233ebf6331cb79ea7b93a3970fb2eabf32"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f736fbec1de285b9d5280327ea89872b02c06cac696357b33aa8384477c8d099"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f736fbec1de285b9d5280327ea89872b02c06cac696357b33aa8384477c8d099"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f736fbec1de285b9d5280327ea89872b02c06cac696357b33aa8384477c8d099"
    sha256 cellar: :any_skip_relocation, sonoma:        "88e0a1051421c954663fa4522db5b8a23ea8fffad5ac1e6f6c3f1047907d5e70"
    sha256 cellar: :any_skip_relocation, ventura:       "88e0a1051421c954663fa4522db5b8a23ea8fffad5ac1e6f6c3f1047907d5e70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7d4679fbda4d4df5a39c5593ce3a66b67490058cc1febd89e554341e6ffebdd"
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
