class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/glideapps/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.2.0.tgz"
  sha256 "b6f257badbb64c56fca9e5a30a09d69ffd5927504ed443d0b291fcba0231a426"
  license "Apache-2.0"
  head "https://github.com/glideapps/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2b95ad6c08db5cef30c86e3457e1871b7e29b655103f10a585caed6bd1fecb6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2b95ad6c08db5cef30c86e3457e1871b7e29b655103f10a585caed6bd1fecb6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c2b95ad6c08db5cef30c86e3457e1871b7e29b655103f10a585caed6bd1fecb6"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c4b31e954ac4b666cdde1b7f97bc317c6592d7d4ca3a63efb7e043ca80d9926"
    sha256 cellar: :any_skip_relocation, ventura:       "3c4b31e954ac4b666cdde1b7f97bc317c6592d7d4ca3a63efb7e043ca80d9926"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2b95ad6c08db5cef30c86e3457e1871b7e29b655103f10a585caed6bd1fecb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2b95ad6c08db5cef30c86e3457e1871b7e29b655103f10a585caed6bd1fecb6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"sample.json").write <<~JSON
      {
        "i": [0, 1],
        "s": "quicktype"
      }
    JSON
    output = shell_output("#{bin}/quicktype --lang typescript --src sample.json")
    assert_match "i: number[];", output
    assert_match "s: string;", output
  end
end
