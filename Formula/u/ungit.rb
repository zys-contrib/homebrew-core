class Ungit < Formula
  desc "Easiest way to use Git. On any platform. Anywhere"
  homepage "https://github.com/FredrikNoren/ungit"
  url "https://registry.npmjs.org/ungit/-/ungit-1.5.27.tgz"
  sha256 "daea92ea66ac52f8359c9964f68779dea7ba1583621bf87473e719395992364c"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "40d50a00a6fcb1bd6b995a309b2ec6b8ad7d0bf5bffbc34b20423232d123ff0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40d50a00a6fcb1bd6b995a309b2ec6b8ad7d0bf5bffbc34b20423232d123ff0a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40d50a00a6fcb1bd6b995a309b2ec6b8ad7d0bf5bffbc34b20423232d123ff0a"
    sha256 cellar: :any_skip_relocation, sonoma:         "3f9d30cf8403390943062e14226a067f130c608db317dd46eda8a742c30ac808"
    sha256 cellar: :any_skip_relocation, ventura:        "3f9d30cf8403390943062e14226a067f130c608db317dd46eda8a742c30ac808"
    sha256 cellar: :any_skip_relocation, monterey:       "3f9d30cf8403390943062e14226a067f130c608db317dd46eda8a742c30ac808"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40d50a00a6fcb1bd6b995a309b2ec6b8ad7d0bf5bffbc34b20423232d123ff0a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    port = free_port

    fork do
      exec bin/"ungit", "--no-launchBrowser", "--port=#{port}"
    end
    sleep 15

    assert_includes shell_output("curl -s 127.0.0.1:#{port}/"), "<title>ungit</title>"
  end
end
