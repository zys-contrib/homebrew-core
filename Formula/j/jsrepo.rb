class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-1.41.4.tgz"
  sha256 "6cee2db8ad0221e13acd0351d673d38c178cf8decaf28bb56b7423358d7b8d68"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6d438c92f20061e0d4b112892c5e930f6262d4c91c16dd61a31cd25efa16fd6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6d438c92f20061e0d4b112892c5e930f6262d4c91c16dd61a31cd25efa16fd6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f6d438c92f20061e0d4b112892c5e930f6262d4c91c16dd61a31cd25efa16fd6"
    sha256 cellar: :any_skip_relocation, sonoma:        "22d4ea0bef1f87f13517d9fbd19db39d8887431ad02f9399090a978d37de75b7"
    sha256 cellar: :any_skip_relocation, ventura:       "22d4ea0bef1f87f13517d9fbd19db39d8887431ad02f9399090a978d37de75b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6d438c92f20061e0d4b112892c5e930f6262d4c91c16dd61a31cd25efa16fd6"
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
