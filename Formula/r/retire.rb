class Retire < Formula
  desc "Scanner detecting the use of JavaScript libraries with known vulnerabilities"
  homepage "https://retirejs.github.io/retire.js/"
  url "https://registry.npmjs.org/retire/-/retire-5.1.3.tgz"
  sha256 "7e9682706a257f58c67c685883daa918619e6f47faafba80e94780aa99d443a6"
  license "Apache-2.0"
  head "https://github.com/RetireJS/retire.js.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d53a179ee5816ab0d330a4eedf30a1e3b5a6e2a71201a288da096cd0a98299b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d53a179ee5816ab0d330a4eedf30a1e3b5a6e2a71201a288da096cd0a98299b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d53a179ee5816ab0d330a4eedf30a1e3b5a6e2a71201a288da096cd0a98299b3"
    sha256 cellar: :any_skip_relocation, sonoma:         "d53a179ee5816ab0d330a4eedf30a1e3b5a6e2a71201a288da096cd0a98299b3"
    sha256 cellar: :any_skip_relocation, ventura:        "d53a179ee5816ab0d330a4eedf30a1e3b5a6e2a71201a288da096cd0a98299b3"
    sha256 cellar: :any_skip_relocation, monterey:       "d53a179ee5816ab0d330a4eedf30a1e3b5a6e2a71201a288da096cd0a98299b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61f3b49145326f0c569b1012186891532bc31dd1120ef7a12e0088dd9cfe0fc7"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/retire --version")

    system "git", "clone", "https://github.com/appsecco/dvna.git"
    output = shell_output("#{bin}/retire --path dvna 2>&1", 13)
    assert_match(/jquery (\d+(?:\.\d+)+) has known vulnerabilities/, output)
  end
end
