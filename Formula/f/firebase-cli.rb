class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-13.15.3.tgz"
  sha256 "c9b8c3973228b8b56986ce744e378d7afd8b676c7f72ad7a9b4301f6b596f126"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "94567b5a6311527862f997918e1b1b0cd655e067d42c687d6a6b9b1b06cee325"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94567b5a6311527862f997918e1b1b0cd655e067d42c687d6a6b9b1b06cee325"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94567b5a6311527862f997918e1b1b0cd655e067d42c687d6a6b9b1b06cee325"
    sha256 cellar: :any_skip_relocation, sonoma:         "6d804bfb1783dbe0a9338ea968236cf3a49aaf366ab278be19fe62efd86d9b05"
    sha256 cellar: :any_skip_relocation, ventura:        "6d804bfb1783dbe0a9338ea968236cf3a49aaf366ab278be19fe62efd86d9b05"
    sha256 cellar: :any_skip_relocation, monterey:       "6d804bfb1783dbe0a9338ea968236cf3a49aaf366ab278be19fe62efd86d9b05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ae9a0bce578cf2fb02239f53a469d19467b6ea18fb1f3a31e2a36bf5d4fd97b"
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/firebase login:ci --no-localhost
      expect "Paste"
    EOS
    assert_match "authorization code", shell_output("expect -f test.exp")
  end
end
