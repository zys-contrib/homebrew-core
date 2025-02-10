class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-15.0.7.tgz"
  sha256 "4e3fbc70248d5f40e562e5185bd3babcabbf24f423bdd4c11464dd6adf443f4d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0705f5a9ad71aaf0890c741f293e84fbe9951f0a967989b19c7e8e14ee986ddc"
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
