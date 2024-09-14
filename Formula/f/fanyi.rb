class Fanyi < Formula
  desc "Chinese and English translate tool in your command-line"
  homepage "https://github.com/afc163/fanyi"
  url "https://registry.npmjs.org/fanyi/-/fanyi-9.0.4.tgz"
  sha256 "a65079079fe082096a5c94fbb59381d8470cf532758e04df53acfefe0e196692"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "79e56b0b5ab12581cb88e33f0a1413b9dfaacaeb876c538b80fa25c18d8bad71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "79e56b0b5ab12581cb88e33f0a1413b9dfaacaeb876c538b80fa25c18d8bad71"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79e56b0b5ab12581cb88e33f0a1413b9dfaacaeb876c538b80fa25c18d8bad71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79e56b0b5ab12581cb88e33f0a1413b9dfaacaeb876c538b80fa25c18d8bad71"
    sha256 cellar: :any_skip_relocation, sonoma:         "14b94f46a7c03117bc78e7a012325796e005d0a6ddc4d7eb6c595a692f3f3cb9"
    sha256 cellar: :any_skip_relocation, ventura:        "14b94f46a7c03117bc78e7a012325796e005d0a6ddc4d7eb6c595a692f3f3cb9"
    sha256 cellar: :any_skip_relocation, monterey:       "14b94f46a7c03117bc78e7a012325796e005d0a6ddc4d7eb6c595a692f3f3cb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae5ef133343ea7ab08e3d3e643ccf365aac5cad11fc1709c89c1550bca46d552"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "爱", shell_output("#{bin}/fanyi love 2>/dev/null")
  end
end
