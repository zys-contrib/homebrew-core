class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-6.1.0.tgz"
  sha256 "36b851cfb408c1c4c2d0080168791afd5390a88c1db74f2747b65b7572eb293e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c8d32503ea8098d1b4053a18d4cc6903e12313298805241a91a672aec81e40f7"
    sha256 cellar: :any,                 arm64_sonoma:  "c8d32503ea8098d1b4053a18d4cc6903e12313298805241a91a672aec81e40f7"
    sha256 cellar: :any,                 arm64_ventura: "c8d32503ea8098d1b4053a18d4cc6903e12313298805241a91a672aec81e40f7"
    sha256 cellar: :any,                 sonoma:        "7c41e5c7470c2e05634a009d6a229248834a99958705e88afd8b223386f7102f"
    sha256 cellar: :any,                 ventura:       "7c41e5c7470c2e05634a009d6a229248834a99958705e88afd8b223386f7102f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a705ad76dc3685c1ce55c558b41149e28299c12251f7b81c0e0c4fca3b4fcf73"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/vite optimize --force")
    assert_match "Forced re-optimization of dependencies", output

    output = shell_output("#{bin}/vite optimize")
    assert_match "Hash is consistent. Skipping.", output

    assert_match version.to_s, shell_output("#{bin}/vite --version")
  end
end
