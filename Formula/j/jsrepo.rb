class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-1.39.0.tgz"
  sha256 "5f7d0986a94377e0e664e1c71967998b7f5d9cd804f82c29156142f5b3d85367"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35871b3db3a970d2ef7f098a272ace12715ac7afa9f92206a240635fc4671f4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35871b3db3a970d2ef7f098a272ace12715ac7afa9f92206a240635fc4671f4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "35871b3db3a970d2ef7f098a272ace12715ac7afa9f92206a240635fc4671f4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "04847931900d298fb6afcdb6a717a64e195a7ab5ae3c0a34f5b1f195faf783fc"
    sha256 cellar: :any_skip_relocation, ventura:       "04847931900d298fb6afcdb6a717a64e195a7ab5ae3c0a34f5b1f195faf783fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35871b3db3a970d2ef7f098a272ace12715ac7afa9f92206a240635fc4671f4e"
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
