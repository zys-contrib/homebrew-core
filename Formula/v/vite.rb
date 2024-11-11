class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.4.11.tgz"
  sha256 "e970ff612f455681c5e56ea699ec0828c68ffa89e05aa135ae4d7d0326b5198a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "927201548c39fee5fb3efcf3a1ad010904ce88ee94c6057cb92cd26b7b33b8b8"
    sha256 cellar: :any,                 arm64_sonoma:  "927201548c39fee5fb3efcf3a1ad010904ce88ee94c6057cb92cd26b7b33b8b8"
    sha256 cellar: :any,                 arm64_ventura: "927201548c39fee5fb3efcf3a1ad010904ce88ee94c6057cb92cd26b7b33b8b8"
    sha256 cellar: :any,                 sonoma:        "9f853cd75a498efcabe5b5f3592346791a702e5b5addcc5f363e8731652ae3ef"
    sha256 cellar: :any,                 ventura:       "9f853cd75a498efcabe5b5f3592346791a702e5b5addcc5f363e8731652ae3ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b36d562a338900f5c535146d91d49f24a9c54a0a75f5c539552fc40e970ab939"
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
