class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-2.0.2.tgz"
  sha256 "cbc072816a6a93aa0512e8af916b9ea6c553f171bf32ae0f8b02fce6762fbb48"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1033bccd536be9975706b253745bbdc9d0773c48252199d1f9bb4f2e60df7c1d"
    sha256 cellar: :any,                 arm64_sonoma:  "1033bccd536be9975706b253745bbdc9d0773c48252199d1f9bb4f2e60df7c1d"
    sha256 cellar: :any,                 arm64_ventura: "1033bccd536be9975706b253745bbdc9d0773c48252199d1f9bb4f2e60df7c1d"
    sha256 cellar: :any,                 sonoma:        "5df56f3bb0985f4424729b74303c9c1907f9d3bc11e674f21df9c5b17f7d6428"
    sha256 cellar: :any,                 ventura:       "5df56f3bb0985f4424729b74303c9c1907f9d3bc11e674f21df9c5b17f7d6428"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b437700ccbd423a5b13b74265ba715f09c4194887f0e2633a78b38c44899ad6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "369b796b42906a9c4b83a6b2a59764c5fd844a6221a7fc08ea6bf014fdc2028d"
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
