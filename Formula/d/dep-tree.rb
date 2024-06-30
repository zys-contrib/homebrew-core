class DepTree < Formula
  desc "Tool for visualizing dependencies between files and enforcing dependency rules"
  homepage "https://github.com/gabotechs/dep-tree"
  url "https://github.com/gabotechs/dep-tree/archive/refs/tags/v0.22.5.tar.gz"
  sha256 "09ca8eea34d1786db5ab9039d9edaaa9d5152812450f20b6329b1c0470f0b165"
  license "MIT"
  head "https://github.com/gabotechs/dep-tree.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2ccd25e65e1160440fca987398eebb77b20cef3e236ad649e2de50d41f7d28c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec07b9efb3d4868dcdb4aa110e248f6829f08f872679389015b1a24070832714"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43110c4488d035a2db92978fe7d9cbb88f90b37240929f4c578f47291aaf5408"
    sha256 cellar: :any_skip_relocation, sonoma:         "32dfcd37266880b782757171aa5c2ad6f5a00f6f5b1f0ba111a64d0c8630b532"
    sha256 cellar: :any_skip_relocation, ventura:        "d2558710a9a58bd840ed08299da39d123b70cdd301bdb8cea0d70eaad0c66c04"
    sha256 cellar: :any_skip_relocation, monterey:       "b55b4ca68350ddd03b2d9fee591fef82f548900b0aecca41276ebeb00c7d20d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d5b26050609780d6282683a6d7099cc77013cb7835150ce5b061cac86016584"
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
