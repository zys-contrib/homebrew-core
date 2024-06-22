class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https://github.com/Zxilly/go-size-analyzer"
  url "https://github.com/Zxilly/go-size-analyzer/archive/refs/tags/v1.3.8.tar.gz"
  sha256 "4bc9d1d21c5d929b73bd558d2a3bafee95a230d7ea39eeaf3abf62d9f6c02aa5"
  license "AGPL-3.0-only"
  head "https://github.com/Zxilly/go-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "625fb80bda6bd4906409ec482e6872de09450194af38b381d6117b4c0c927df9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "690c10370c5b44c12147fa973fcc18ace10479e21989faee81161775656274d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "489e8c8c66b730d3eff2b84a60e2789044932e2a3dcc813ceeafa29320acb3c8"
    sha256 cellar: :any_skip_relocation, sonoma:         "4ff574d91028df59d9a63f43590ac82a95b002a9c1d95ba52f7ece12418a49ad"
    sha256 cellar: :any_skip_relocation, ventura:        "345e2870fd93d19bba554b0ed241a0924b25629a7694787b2f3ab4e85c32a48f"
    sha256 cellar: :any_skip_relocation, monterey:       "a4971eb01fdc5326163d483c303aa22187248850d056dae3333938b3f0460d21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "928f9f2a9147b3da1daad3f20075a6d467cbb586053fd5061e694498cc3a76ea"
  end

  depends_on "go" => [:build, :test]
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "--dir", "ui", "install"
    system "pnpm", "--dir", "ui", "build:ui"

    mv "ui/dist/webui/index.html", "internal/webui/index.html"

    ldflags = %W[
      -s -w
      -X github.com/Zxilly/go-size-analyzer.version=#{version}
      -X github.com/Zxilly/go-size-analyzer.buildDate=#{Time.now.iso8601}
      -X github.com/Zxilly/go-size-analyzer.dirtyBuild=false
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"gsa"), "-tags", "embed", "./cmd/gsa"
  end

  test do
    assert_includes shell_output("#{bin}/gsa --version"), version

    assert_includes shell_output("#{bin}/gsa invalid", 1), "Usage"

    (testpath/"hello.go").write <<~EOS
      package main

      import "fmt"

      func main() {
        fmt.Println("Hello, World")
      }
    EOS

    system "go", "build", "-o", testpath/"hello", testpath/"hello.go"

    output = shell_output("#{bin}/gsa #{testpath}/hello 2>&1")

    assert_includes output, "runtime"
    assert_includes output, "main"
  end
end
