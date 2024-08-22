class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.47.0.tgz"
  sha256 "5b9d96590ee021dabc692f021bb8f6ab1716f590c97bad4de4c79e297d3b00ab"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https://github.com/renovatebot/renovate/tags"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e68fc448a37104cee11b0a9589e1be67829e0b5416d3f9a7eac4ff26dbf41f75"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "004de6a9795c98aa4e90ae973f70d693d50ccf694d98f9cf0373851b4d48347a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03b18e7fb65dd779d1b526f14a5ddb3d252bfd60b5c3cea184f9b295f0d759b5"
    sha256 cellar: :any_skip_relocation, sonoma:         "3780456f7e1800372bbb20e1183029bd033cf28681989146a8f7dd30e69250fa"
    sha256 cellar: :any_skip_relocation, ventura:        "daa96a316f46a3739fa331412b51249b922b8f134545f9983d2a342e3afa6270"
    sha256 cellar: :any_skip_relocation, monterey:       "998ef65ad691228c699a13250342c17b711118e3fb6a787471ee1a3c7a35ffda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47e5ae1d9c8397fc90372ead69d0b656ca33c23be3ccf82eafe95d0936c70c5c"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end
