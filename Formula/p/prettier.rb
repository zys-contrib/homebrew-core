require "language/node"

class Prettier < Formula
  desc "Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML"
  homepage "https://prettier.io/"
  url "https://registry.npmjs.org/prettier/-/prettier-3.3.3.tgz"
  sha256 "2f1ecb0ab57a588e0d4d40d3d45239e71ebd8f0190199d0d3f87fe2283639f46"
  license "MIT"
  head "https://github.com/prettier/prettier.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bf27af9f228a7857a92e337e48b8c452b8706dc85f0720b4ff01597672fb83c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf27af9f228a7857a92e337e48b8c452b8706dc85f0720b4ff01597672fb83c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf27af9f228a7857a92e337e48b8c452b8706dc85f0720b4ff01597672fb83c9"
    sha256 cellar: :any_skip_relocation, sonoma:         "bf27af9f228a7857a92e337e48b8c452b8706dc85f0720b4ff01597672fb83c9"
    sha256 cellar: :any_skip_relocation, ventura:        "bf27af9f228a7857a92e337e48b8c452b8706dc85f0720b4ff01597672fb83c9"
    sha256 cellar: :any_skip_relocation, monterey:       "bf27af9f228a7857a92e337e48b8c452b8706dc85f0720b4ff01597672fb83c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1c6f6d9aa72c4ca1d1d2b824494ce415a086497821537eb0aed76824de5a68f"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.js").write("const arr = [1,2];")
    output = shell_output("#{bin}/prettier test.js")
    assert_equal "const arr = [1, 2];", output.chomp
  end
end
