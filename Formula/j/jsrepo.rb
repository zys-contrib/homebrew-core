class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-1.39.3.tgz"
  sha256 "12091bb449ccf91f708f71c007b5c22278cb2d8816f4866371e9f88d5ff6b20c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92b3b01569ae10ccd668f8dfa12ab9bb7d601f450fd63772e5c74ea2f15bb5df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92b3b01569ae10ccd668f8dfa12ab9bb7d601f450fd63772e5c74ea2f15bb5df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "92b3b01569ae10ccd668f8dfa12ab9bb7d601f450fd63772e5c74ea2f15bb5df"
    sha256 cellar: :any_skip_relocation, sonoma:        "a332a61e398fc52b435b4cbda635a07a7757001aceadfb476940e4b767bda457"
    sha256 cellar: :any_skip_relocation, ventura:       "a332a61e398fc52b435b4cbda635a07a7757001aceadfb476940e4b767bda457"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92b3b01569ae10ccd668f8dfa12ab9bb7d601f450fd63772e5c74ea2f15bb5df"
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
