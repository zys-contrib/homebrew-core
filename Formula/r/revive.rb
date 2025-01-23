class Revive < Formula
  desc "Fast, configurable, extensible, flexible, and beautiful linter for Go"
  homepage "https://revive.run"
  url "https://github.com/mgechev/revive.git",
      tag:      "v1.6.0",
      revision: "d9c61c1518f16418ad94d92b2d5976c266e0ad6e"
  license "MIT"
  head "https://github.com/mgechev/revive.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e269b45094637b8e11dd11a57dcd8efae2c6d8b036f529e0b7e5d8efbb8ea7d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e269b45094637b8e11dd11a57dcd8efae2c6d8b036f529e0b7e5d8efbb8ea7d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e269b45094637b8e11dd11a57dcd8efae2c6d8b036f529e0b7e5d8efbb8ea7d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "23432d2d934e2fc3ce768eb0c7cf0d8da04919a50d771aaeb4ed35b29a90ce86"
    sha256 cellar: :any_skip_relocation, ventura:       "23432d2d934e2fc3ce768eb0c7cf0d8da04919a50d771aaeb4ed35b29a90ce86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7654c411b10b2628d31b23f7ed265b3437cd8d9f13579d0b029a4cb3f5b9cd77"
  end

  depends_on "go" => [:build, :test]

  def install
    ldflags = %W[
      -s -w
      -X github.com/mgechev/revive/cli.commit=#{Utils.git_head}
      -X github.com/mgechev/revive/cli.date=#{time.iso8601}
      -X github.com/mgechev/revive/cli.builtBy=#{tap.user}
    ]
    ldflags << "-X github.com/mgechev/revive/cli.version=#{version}" unless build.head?

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/revive -version")

    (testpath/"main.go").write <<~GO
      package main

      import "fmt"

      func main() {
        my_string := "Hello from Homebrew"
        fmt.Println(my_string)
      }
    GO

    system "go", "mod", "init", "brewtest"
    output = shell_output("#{bin}/revive main.go")
    assert_match "don't use underscores in Go names", output
  end
end
