class DepTree < Formula
  desc "Tool for visualizing dependencies between files and enforcing dependency rules"
  homepage "https://github.com/gabotechs/dep-tree"
  url "https://github.com/gabotechs/dep-tree/archive/refs/tags/v0.23.3.tar.gz"
  sha256 "c6257189f94d3ff5bd37a178168c8274bdcb3f3b4fc874061c0cbd7f53ed65d2"
  license "MIT"
  head "https://github.com/gabotechs/dep-tree.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16666caea781c30e0d864f3fabe2d644c58df864da8ffb7660deaae739d677e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16666caea781c30e0d864f3fabe2d644c58df864da8ffb7660deaae739d677e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "16666caea781c30e0d864f3fabe2d644c58df864da8ffb7660deaae739d677e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d152f90ffef03f9dac251557f9602db777775dcd8e6d707d1c7609849d34dac"
    sha256 cellar: :any_skip_relocation, ventura:       "9d152f90ffef03f9dac251557f9602db777775dcd8e6d707d1c7609849d34dac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfa4f7b7d228c2340ed942cf28d679675451bd532257856c047431a1da4b39d1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"foo.js").write <<~JS
      import { bar } from './bar'
    JS
    (testpath/"bar.js").write <<~JS
      export const bar = 'bar'
    JS
    (testpath/"package.json").write <<~JSON
      { "name": "foo" }
    JSON
    expected = <<~JSON
      {
        "tree": {
          "foo.js": {
            "bar.js": null
          }
        },
        "circularDependencies": [],
        "errors": {}
      }
    JSON

    assert_equal expected, shell_output("#{bin}/dep-tree tree --json #{testpath}/foo.js")
  end
end
