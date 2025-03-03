class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-1.41.3.tgz"
  sha256 "7bd9cb919c22fa30cb009cef6ad0245a5643ee8f7a976459ed66a80ca55640c0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1c2360b884df304fa189eb8b8864befacedae4009adc1faba141edaba526e1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1c2360b884df304fa189eb8b8864befacedae4009adc1faba141edaba526e1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f1c2360b884df304fa189eb8b8864befacedae4009adc1faba141edaba526e1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d531de618b189831819754c0820343d81f0d3e018c32483a6a11acd7656699c3"
    sha256 cellar: :any_skip_relocation, ventura:       "d531de618b189831819754c0820343d81f0d3e018c32483a6a11acd7656699c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1c2360b884df304fa189eb8b8864befacedae4009adc1faba141edaba526e1c"
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
