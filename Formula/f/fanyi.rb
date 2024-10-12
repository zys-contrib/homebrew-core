class Fanyi < Formula
  desc "Chinese and English translate tool in your command-line"
  homepage "https://github.com/afc163/fanyi"
  url "https://registry.npmjs.org/fanyi/-/fanyi-9.0.7.tgz"
  sha256 "1350cd20a2b461ea1ed8acd955f8ef7097c6436c1bdffac0efe622dc70ad4586"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "647b163411b47fcecd6c1342116888679b0a75a78ed2af252bc11efa507f39c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "647b163411b47fcecd6c1342116888679b0a75a78ed2af252bc11efa507f39c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "647b163411b47fcecd6c1342116888679b0a75a78ed2af252bc11efa507f39c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "dcb306e52d34c98e9183e2bc2260bc5e210a1473afe4da9f4dd54f63858bbecc"
    sha256 cellar: :any_skip_relocation, ventura:       "dcb306e52d34c98e9183e2bc2260bc5e210a1473afe4da9f4dd54f63858bbecc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "647b163411b47fcecd6c1342116888679b0a75a78ed2af252bc11efa507f39c3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "爱", shell_output("#{bin}/fanyi love 2>/dev/null")
    assert_match version.to_s, shell_output("#{bin}/fanyi --version")
  end
end
