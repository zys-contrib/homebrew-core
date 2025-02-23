class Cxgo < Formula
  desc "Transpiling C to Go"
  homepage "https://github.com/gotranspile/cxgo"
  url "https://github.com/gotranspile/cxgo/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "231230723572d49bc74b9d58c9f15700cbd3b9287d6e281b8d53cb580ad58d3e"
  license "MIT"
  head "https://github.com/gotranspile/cxgo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b98556bfbd62b06a623e825d495a714c17679a71a179b7e6c4bd180303ab7e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b98556bfbd62b06a623e825d495a714c17679a71a179b7e6c4bd180303ab7e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6b98556bfbd62b06a623e825d495a714c17679a71a179b7e6c4bd180303ab7e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e8587aa4932c76cb8d97dbbe6ec70074f522005a2803050aa30096337e89da4"
    sha256 cellar: :any_skip_relocation, ventura:       "7e8587aa4932c76cb8d97dbbe6ec70074f522005a2803050aa30096337e89da4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b857eada57e6a2a1502c16e1d23faac1b6a82ed24d04eddfbb0b9e2e358f4eaf"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/cxgo"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      int main() {
        printf("Hello, World!");
        return 0;
      }
    C

    expected = <<~GO
      package main

      import (
      \t"github.com/gotranspile/cxgo/runtime/stdio"
      \t"os"
      )

      func main() {
      \tstdio.Printf("Hello, World!")
      \tos.Exit(0)
      }
    GO

    system bin/"cxgo", "file", testpath/"test.c"
    assert_equal expected, (testpath/"test.go").read

    assert_match version.to_s, shell_output("#{bin}/cxgo version")
  end
end
