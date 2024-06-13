class DepTree < Formula
  desc "Tool for visualizing dependencies between files and enforcing dependency rules"
  homepage "https://github.com/gabotechs/dep-tree"
  url "https://github.com/gabotechs/dep-tree/archive/refs/tags/v0.20.7.tar.gz"
  sha256 "a89ac0975b01cfb4785090b0a28ea822079523a407c958fb4eb0703e326a3f12"
  license "MIT"
  head "https://github.com/gabotechs/dep-tree.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5d71f9df94a89e1d4437d6e81847570ef0ca763805eef364a07f84258dbd2cdf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5df6fcd4fda8a1292b1716e398883b25a9e90f3727512d5e13c2f35f842c5cb0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c2bee4ee5b09bd00b8841b8004fb611d830680c55875524d8e5c70c92f902c4"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c5595a882cfcccff4c48082f01f562b0879bb8ecfe1b3506cde00aecc315244"
    sha256 cellar: :any_skip_relocation, ventura:        "cf36c4f0c5022b75c8bbf996554f45811ab533fe0aad1402541da9591d255451"
    sha256 cellar: :any_skip_relocation, monterey:       "43371e0351ffe82069265a7698f118563510dffc70ddbf0b70165fc7bd2bf9a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2e56b8bc3cf2805f9d310fa0594330598393c474b600fd5e2e1a5e40e4798ed"
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
