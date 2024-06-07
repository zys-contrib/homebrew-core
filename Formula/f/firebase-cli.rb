require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-13.11.1.tgz"
  sha256 "f8a954944892930cf1bdaa3a630a962e4eb1bcedc4ced7002a20a6a5a23444a3"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b951b57b6fffeac33b4f23a965271f242d79baac28444f0b54a4f1902acc27ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b951b57b6fffeac33b4f23a965271f242d79baac28444f0b54a4f1902acc27ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b951b57b6fffeac33b4f23a965271f242d79baac28444f0b54a4f1902acc27ec"
    sha256 cellar: :any_skip_relocation, sonoma:         "6cdc268d5cdae09985b107be26db7809f5902ee5daaef17953f04eb69b6c685c"
    sha256 cellar: :any_skip_relocation, ventura:        "6cdc268d5cdae09985b107be26db7809f5902ee5daaef17953f04eb69b6c685c"
    sha256 cellar: :any_skip_relocation, monterey:       "6cdc268d5cdae09985b107be26db7809f5902ee5daaef17953f04eb69b6c685c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32f32ad33961d6645e47940a497f31811953aabbad79bdad3734b9c096290456"
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
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
