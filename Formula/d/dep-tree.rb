class DepTree < Formula
  desc "Tool for visualizing dependencies between files and enforcing dependency rules"
  homepage "https://github.com/gabotechs/dep-tree"
  url "https://github.com/gabotechs/dep-tree/archive/refs/tags/v0.22.2.tar.gz"
  sha256 "e68cbd15b41adfc72bbb3602de245622acbeb4b0b7cb711e052fdd7cbed6de64"
  license "MIT"
  head "https://github.com/gabotechs/dep-tree.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "509ac97ab510641e024942a555d5f72cd071ed02208b1d5898fa241033215021"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cff862b14bc1936a77c20b11f3743b48fd4907e57d44de5b63d0c1c76982d2f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7510a530e3d101fa538ab615d172c78970b1f46a687b0fb6b8d350d12f080ff"
    sha256 cellar: :any_skip_relocation, sonoma:         "1c667c325c0b7b5dde483172ac0dde148230d1d5230411cf02ae2725f3093ef8"
    sha256 cellar: :any_skip_relocation, ventura:        "b7263d55b93115c9671842515a9513ac8e5ba3fe75d4f62b142f2dc7725ef828"
    sha256 cellar: :any_skip_relocation, monterey:       "cf83e2ad81dea39fa5d3f6a1f97f6af661ada0110e92c267c38bc8394cf60e04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a2141d144c81dbf179120f4ab7d89f0dffe369b7837d02842029a9c6a3f5172"
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
