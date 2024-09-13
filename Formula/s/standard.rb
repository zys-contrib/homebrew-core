class Standard < Formula
  desc "JavaScript Style Guide, with linter & automatic code fixer"
  homepage "https://standardjs.com/"
  url "https://registry.npmjs.org/standard/-/standard-17.1.1.tgz"
  sha256 "b763344dd2c24f00d8690d881c826c8f23f67d7afe616d7ad1889fd3b4d144f5"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2e18ec6105743cbe10e4cff9c909a37057e40a42cb5bf72711424c7612db730e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2d06a373849759c1b455daca6ba136aae42fd595a61a879822d2e296a203a13f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d06a373849759c1b455daca6ba136aae42fd595a61a879822d2e296a203a13f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d06a373849759c1b455daca6ba136aae42fd595a61a879822d2e296a203a13f"
    sha256 cellar: :any_skip_relocation, sonoma:         "282a80dbf34a60f7e44a4a78d6ee35ae579ff7ba4783c631162c2c5289b391be"
    sha256 cellar: :any_skip_relocation, ventura:        "282a80dbf34a60f7e44a4a78d6ee35ae579ff7ba4783c631162c2c5289b391be"
    sha256 cellar: :any_skip_relocation, monterey:       "282a80dbf34a60f7e44a4a78d6ee35ae579ff7ba4783c631162c2c5289b391be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bc78f5c4f7351ad1fbc152ae3869fe81b77a7047b41fea80f09bfe1a76ead1d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    test_foo = testpath/"foo.js"
    test_foo.write "console.log(\"hello there\")"
    output = shell_output("#{bin}/standard #{test_foo} 2>&1", 1)
    assert_match "Strings must use singlequote. (quotes)", output

    test_bar = testpath/"bar.js"
    test_bar.write "if (name != 'John') { }"
    output = shell_output("#{bin}/standard #{test_bar} 2>&1", 1)
    assert_match "Expected '!==' and instead saw '!='. (eqeqeq)", output
    assert_match "Empty block statement. (no-empty)", output

    assert_match version.to_s, shell_output("#{bin}/standard --version")
  end
end
