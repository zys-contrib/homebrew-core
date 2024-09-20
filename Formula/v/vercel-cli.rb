class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-37.5.3.tgz"
  sha256 "a8ae05e7671e54839f86d441878f84690708f08147e7f366359159fc040aa76d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24af53ac5be4ba94ba88c9274056263915d5010b4b0cb67725f904b9f965a940"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24af53ac5be4ba94ba88c9274056263915d5010b4b0cb67725f904b9f965a940"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "24af53ac5be4ba94ba88c9274056263915d5010b4b0cb67725f904b9f965a940"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2661f1c06be4d8fce8e543e6741b2802b541fd625ec898056147d0d0c5cb55c"
    sha256 cellar: :any_skip_relocation, ventura:       "a2661f1c06be4d8fce8e543e6741b2802b541fd625ec898056147d0d0c5cb55c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1622e7a14b948f75a3ad6e48c1460d753a12aa9801bf3edb749f134437139cd"
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
