class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-2.3.0.tgz"
  sha256 "17ea7dae5f11c243218ef89ebacc8b824eb39da01eb8763505e1d3917ce205ea"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "abc94954a351d463f8c6543733c1d198742a830c06374f51046efa9b6ab55363"
    sha256 cellar: :any,                 arm64_sonoma:  "abc94954a351d463f8c6543733c1d198742a830c06374f51046efa9b6ab55363"
    sha256 cellar: :any,                 arm64_ventura: "abc94954a351d463f8c6543733c1d198742a830c06374f51046efa9b6ab55363"
    sha256 cellar: :any,                 sonoma:        "1a38375291ecd14e03a2b405d15e21497522b5797d2ae5afaf70d5726d0db620"
    sha256 cellar: :any,                 ventura:       "1a38375291ecd14e03a2b405d15e21497522b5797d2ae5afaf70d5726d0db620"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8938351eb54e806adf12a68060e1da2db1c258dba114afb03561e44e163a1a06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7d1349e846f7557dfcb8bcbae59dd71871eaed8855f6d6fb9b9affb3c369c57"
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
