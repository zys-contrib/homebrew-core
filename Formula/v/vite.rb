class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.4.8.tgz"
  sha256 "0ea4fafa19783ea955192478cd7ef2b5b305a4f08752018c38eb1bdade3af888"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "17274d90a9c59f389b78772dca522e784b04e267d3cc7568e87d582670d30d44"
    sha256 cellar: :any,                 arm64_sonoma:  "17274d90a9c59f389b78772dca522e784b04e267d3cc7568e87d582670d30d44"
    sha256 cellar: :any,                 arm64_ventura: "17274d90a9c59f389b78772dca522e784b04e267d3cc7568e87d582670d30d44"
    sha256 cellar: :any,                 sonoma:        "c9e734f0c4dbff8a34bb57a476eae3697dc2d00217e403ae41cb6339362b9ca3"
    sha256 cellar: :any,                 ventura:       "c9e734f0c4dbff8a34bb57a476eae3697dc2d00217e403ae41cb6339362b9ca3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c0a1a2d02743a9eb5e24876e8f6979cc7231816e7eaaef02fdb60bc4f1486e9"
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
