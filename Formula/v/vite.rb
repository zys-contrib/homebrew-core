class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-6.2.1.tgz"
  sha256 "48dd4560e0b8f6608ae7bdb19746748b82b831247d996f1c98e7b1a6e99a7e0a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9d21932b94ebad64658533f34fc9ba1a0f92f0b87faa7d52962fc9f440cccb36"
    sha256 cellar: :any,                 arm64_sonoma:  "9d21932b94ebad64658533f34fc9ba1a0f92f0b87faa7d52962fc9f440cccb36"
    sha256 cellar: :any,                 arm64_ventura: "9d21932b94ebad64658533f34fc9ba1a0f92f0b87faa7d52962fc9f440cccb36"
    sha256 cellar: :any,                 sonoma:        "b796652dc35416acbcb6af6bcedec84ab6c0df0b2908cdfd0fb01371bc4f3134"
    sha256 cellar: :any,                 ventura:       "b796652dc35416acbcb6af6bcedec84ab6c0df0b2908cdfd0fb01371bc4f3134"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a73de7624b6cd54b8cbf2495fbeb92d266cf797bde8170ff781305f7f3f5ec39"
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
