class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-15.0.10.tgz"
  sha256 "ba46cd418f866b4995d6b07e0b6ae49866d59ac032fd62461657ffa404820caa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "56e2352b9c0d293c2079bb8a0791335a4b7f7a293fdf8eaf178a4bf2b4c14d5e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "<p>hello <em>world</em></p>", pipe_output(bin/"marked", "hello *world*").strip
  end
end
