class Mako < Formula
  desc "Production-grade web bundler based on Rust"
  homepage "https://makojs.dev"
  url "https://registry.npmjs.org/@umijs/mako/-/mako-0.11.3.tgz"
  sha256 "6b231e9b1b8faf3a13e9f0e32207cd0a6a25767e265d7499b91a88a7199ec6d8"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9b6148464e5dae545dca0885fd6551ef8e782942de0071eea0a1e0f6449735bf"
    sha256 cellar: :any,                 arm64_sonoma:  "9b6148464e5dae545dca0885fd6551ef8e782942de0071eea0a1e0f6449735bf"
    sha256 cellar: :any,                 arm64_ventura: "9b6148464e5dae545dca0885fd6551ef8e782942de0071eea0a1e0f6449735bf"
    sha256 cellar: :any,                 sonoma:        "d156d59dfb7042baff78040d2d1492af04dabe292299c342516b3bded3899489"
    sha256 cellar: :any,                 ventura:       "d156d59dfb7042baff78040d2d1492af04dabe292299c342516b3bded3899489"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbb3c23456443ca57da33884693df518e5abb2a27bb18e3d685d475f641d74ba"
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
