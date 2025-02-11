class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.io/"
  url "https://github.com/dominikh/go-tools/archive/refs/tags/2025.1.tar.gz"
  sha256 "314e7858de2bc35f7c8ded8537cecf323baf944e657d7075c0d70af9bb3e6d47"
  license "MIT"
  head "https://github.com/dominikh/go-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a797ed009e5ccf0c27881f46408e506f9f6d21532c7814fd1b27297b207e30ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a797ed009e5ccf0c27881f46408e506f9f6d21532c7814fd1b27297b207e30ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a797ed009e5ccf0c27881f46408e506f9f6d21532c7814fd1b27297b207e30ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "66dbe5848a5167104e2482232252478a1049d045eaf273a58ea0c16c1ba3f2df"
    sha256 cellar: :any_skip_relocation, ventura:       "66dbe5848a5167104e2482232252478a1049d045eaf273a58ea0c16c1ba3f2df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9edb3410b3a4e9e42e7ce84b9383c9884edef66ad9a098f64e8911403c959a2"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/staticcheck"
  end

  test do
    system "go", "mod", "init", "brewtest"
    (testpath/"test.go").write <<~GO
      package main

      import "fmt"

      func main() {
        var x uint
        x = 1
        fmt.Println(x)
      }
    GO
    json_output = JSON.parse(shell_output("#{bin}/staticcheck -f json .", 1))
    refute_match "but Staticcheck was built with", json_output["message"]
    assert_equal "S1021", json_output["code"]
  end
end
