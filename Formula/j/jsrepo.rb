class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-1.40.1.tgz"
  sha256 "829d7a5a14dfec8c5b6b7df7ce6b31581db2ac1614e5c2dd86ddd63ac4122825"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2edd6b6e89dfee64056dc48b885f79b8edf2a9dabedc4dc5a372020881ff4804"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2edd6b6e89dfee64056dc48b885f79b8edf2a9dabedc4dc5a372020881ff4804"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2edd6b6e89dfee64056dc48b885f79b8edf2a9dabedc4dc5a372020881ff4804"
    sha256 cellar: :any_skip_relocation, sonoma:        "867e02a2a7fd2a7d769bce77fab29f803dcfb8a2f203e668e79a38c8a81e667e"
    sha256 cellar: :any_skip_relocation, ventura:       "867e02a2a7fd2a7d769bce77fab29f803dcfb8a2f203e668e79a38c8a81e667e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b12ab3b9c7c693527a4b7f4a42c3bc99ad9d824f97df0f9a4eeb6f9c9ae7a1c9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jsrepo --version")

    system bin/"jsrepo", "build"
    assert_match "\"categories\": []", (testpath/"jsrepo-manifest.json").read
  end
end
