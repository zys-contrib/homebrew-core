class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-1.40.0.tgz"
  sha256 "98b872034a39c60ef2406d3a0be2fd5a0446f0a98ffecf129689a59bc329d2bc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "955c847a590d9cadc45c55d0217617e345a6279fdbf9eecf9048db3804fe31e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "955c847a590d9cadc45c55d0217617e345a6279fdbf9eecf9048db3804fe31e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "955c847a590d9cadc45c55d0217617e345a6279fdbf9eecf9048db3804fe31e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d52a887b73a54c99548bc5ef409a9e09ff0dc9c94abd36ec508f5836c1c73ef"
    sha256 cellar: :any_skip_relocation, ventura:       "0d52a887b73a54c99548bc5ef409a9e09ff0dc9c94abd36ec508f5836c1c73ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "955c847a590d9cadc45c55d0217617e345a6279fdbf9eecf9048db3804fe31e1"
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
