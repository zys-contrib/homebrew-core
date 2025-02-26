class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-1.41.2.tgz"
  sha256 "088624c624a577c5b864d1a28a1dc4322ce41ee0a797abc4f047f6265aa4e620"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e8cb75ca28d7aaf7f96928f51cfa9c651c22160ef0ec3cbd8be1f64dd766a23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e8cb75ca28d7aaf7f96928f51cfa9c651c22160ef0ec3cbd8be1f64dd766a23"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7e8cb75ca28d7aaf7f96928f51cfa9c651c22160ef0ec3cbd8be1f64dd766a23"
    sha256 cellar: :any_skip_relocation, sonoma:        "edd84d1e95421a535a6bd92a80ebd5f4fa12ca7fc7b888e8de554e384bb766f7"
    sha256 cellar: :any_skip_relocation, ventura:       "edd84d1e95421a535a6bd92a80ebd5f4fa12ca7fc7b888e8de554e384bb766f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e8cb75ca28d7aaf7f96928f51cfa9c651c22160ef0ec3cbd8be1f64dd766a23"
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
