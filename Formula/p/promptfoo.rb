require "language/node"

class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.62.0.tgz"
  sha256 "b6184c43be0fc4d8bd816be3dc187da364cafe4613f737a880833aee30f19e99"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eb5741e3015bc37eb39787df2cdcd12eb6842e7474d94c035184d432b5216530"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3cb4a4fab39dfbd5c16740ed6fca4201e91f8634d795e5cf7124b3980bc582a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "679ac32c464c2cd235dbffb6932c7f1e26ca5ec52e365c41849f662f95471da0"
    sha256 cellar: :any_skip_relocation, sonoma:         "d3b7fe12f34e09d2bfbae1863527ea655ff5c4a3571b51c9dcf4e22ce634b079"
    sha256 cellar: :any_skip_relocation, ventura:        "4782d88faa9e22eac932453265372e0092d17a873b51514400f6f72873e57b3b"
    sha256 cellar: :any_skip_relocation, monterey:       "70ac43c2d940f5352fd545eadb96551b2cf266cbeeee0a6bc412baee62413108"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a5bfbccef9c98406aec0ab81bbdc415d92aa2c5f5a13aebf0ad8a1ae50ba7dc"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"promptfoo", "init"
    assert_predicate testpath/".promptfoo", :exist?
    assert_match "description: 'My first eval'", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version", 1)
  end
end
