class DepTree < Formula
  desc "Tool for visualizing dependencies between files and enforcing dependency rules"
  homepage "https://github.com/gabotechs/dep-tree"
  url "https://github.com/gabotechs/dep-tree/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "48954c1ecb48c0f441e9cca1e5269756c32bca235e04f74844586a498122cabb"
  license "MIT"
  head "https://github.com/gabotechs/dep-tree.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c25a3e6948dd113caad00537a95154624af3da9e906ceb94246c7c2a575956a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "947b84c40f950b6ba1558570e100f5d12c097d6b0b667cc73bc5c117dfc2f804"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "281687de29f407baed5d2a7abcce0a80fe957a0ad22e80761c799fa6a106c577"
    sha256 cellar: :any_skip_relocation, sonoma:         "0f9aafe1193ba128e3cb66e4b6711b3b2a081f727a5927b021ed9e7b39d86c62"
    sha256 cellar: :any_skip_relocation, ventura:        "86b8c7bef2aa1e67b60d86e312258599c56b9fd1f0460f48a62f3b769d2fed70"
    sha256 cellar: :any_skip_relocation, monterey:       "8243a1e4805a57acefdf3af8d5562628422279e42415147255a221e0b46149f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db836745b5303e9e4de35c852194934c9c1be4d2eb1177f9d9d5eb41817242ae"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    foo_test_file = testpath/"foo.js"
    foo_test_file.write "import { bar } from './bar'"

    bar_test_file = testpath/"bar.js"
    bar_test_file.write "export const bar = 'bar'"

    package_json_file = testpath/"package.json"
    package_json_file.write "{ \"name\": \"foo\" }"

    result_file = testpath/"out.json"
    output = shell_output("#{bin}/dep-tree tree --json #{foo_test_file}")
    result_file.write(output)

    expected = <<~EOF
      {
        "tree": {
          "foo.js": {
            "bar.js": null
          }
        },
        "circularDependencies": [],
        "errors": {}
      }
    EOF
    assert_equal expected, result_file.read
  end
end
