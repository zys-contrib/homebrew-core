class Mako < Formula
  desc "Production-grade web bundler based on Rust"
  homepage "https://makojs.dev"
  url "https://registry.npmjs.org/@umijs/mako/-/mako-0.11.7.tgz"
  sha256 "58b10e13692dc9fabb3caf358cdf9ea98c2e91a7e46714b2eb1d293b6a313b9b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "21e4b0755a910ea4183812d42d359efc6beb49f136a2d18df4041229fe1013ab"
    sha256 cellar: :any,                 arm64_sonoma:  "21e4b0755a910ea4183812d42d359efc6beb49f136a2d18df4041229fe1013ab"
    sha256 cellar: :any,                 arm64_ventura: "21e4b0755a910ea4183812d42d359efc6beb49f136a2d18df4041229fe1013ab"
    sha256 cellar: :any,                 sonoma:        "24e4f150e261161cea6645fe95a1413c0ae1e2fd56b4b937d9ceabf40a7461da"
    sha256 cellar: :any,                 ventura:       "24e4f150e261161cea6645fe95a1413c0ae1e2fd56b4b937d9ceabf40a7461da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9d10005c6b4734d629d2af941863bf864881ac46ab5f8670f07414853397863"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c711e6cb0b7018b2a937bc39787a089068124820a4432695bc9da66192454647"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    libexec.glob("lib/node_modules/@umijs/mako/node_modules/nice-napi/prebuilds/*")
           .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mako --version")

    output = shell_output("#{bin}/mako build 2>&1", 1)
    assert_match(/Load config failed/, output)
  end
end
