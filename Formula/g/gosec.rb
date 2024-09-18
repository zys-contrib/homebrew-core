class Gosec < Formula
  desc "Golang security checker"
  homepage "https://securego.io/"
  url "https://github.com/securego/gosec/archive/refs/tags/v2.21.3.tar.gz"
  sha256 "a055288d34dde54efcf6d3bdc1492d8384d661bf934b345d6db9cd8fc376472d"
  license "Apache-2.0"
  head "https://github.com/securego/gosec.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6e7f99a0844c401bc5fcbd3ddbb390f54fcf2dd81111fed00f89ab2e9ced371f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6e7f99a0844c401bc5fcbd3ddbb390f54fcf2dd81111fed00f89ab2e9ced371f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e7f99a0844c401bc5fcbd3ddbb390f54fcf2dd81111fed00f89ab2e9ced371f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e7f99a0844c401bc5fcbd3ddbb390f54fcf2dd81111fed00f89ab2e9ced371f"
    sha256 cellar: :any_skip_relocation, sonoma:         "c1e70fe291046b67d088d0cac631d248d406557558a0da366eef841760ade47d"
    sha256 cellar: :any_skip_relocation, ventura:        "c1e70fe291046b67d088d0cac631d248d406557558a0da366eef841760ade47d"
    sha256 cellar: :any_skip_relocation, monterey:       "c1e70fe291046b67d088d0cac631d248d406557558a0da366eef841760ade47d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89eb114ea6ad193953ac7cb24217527b7cced9883765c443ff4594beafd12a2b"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}"), "./cmd/gosec"
  end

  test do
    (testpath/"test.go").write <<~EOS
      package main

      import "fmt"

      func main() {
          username := "admin"
          var password = "f62e5bcda4fae4f82370da0c6f20697b8f8447ef"

          fmt.Println("Doing something with: ", username, password)
      }
    EOS

    output = shell_output("#{bin}/gosec ./...", 1)
    assert_match "G101 (CWE-798)", output
    assert_match "Issues : \e[1;31m1\e[0m", output
  end
end
