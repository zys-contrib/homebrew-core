require "language/node"

class Mako < Formula
  desc "Production-grade web bundler based on Rust"
  homepage "https://makojs.dev"
  url "https://registry.npmjs.org/@umijs/mako/-/mako-0.7.4.tgz"
  sha256 "766b99d3116941f67f19cb055c8817c37f52dd1cbeb3b8953e64a3b085a1c38a"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    libexec.glob("lib/node_modules/@umijs/mako/node_modules/nice-napi/prebuilds/*")
           .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mako --version")

    output = shell_output("#{bin}/mako build 2>&1", 1)
    assert_match(/Load config failed/, output)
  end
end
