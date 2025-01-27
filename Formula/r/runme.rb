class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/stateful/runme/archive/refs/tags/v3.11.0.tar.gz"
  sha256 "6c450ef0ea5ff3f14175bb9c5f6be7574b4572bc97168dc2be50a04304a6d4e5"
  license "Apache-2.0"
  head "https://github.com/stateful/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d44d0fb6ad534f16d012e298618e6c6e87f337bc09e9160d48084ba7b5f4265d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d44d0fb6ad534f16d012e298618e6c6e87f337bc09e9160d48084ba7b5f4265d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d44d0fb6ad534f16d012e298618e6c6e87f337bc09e9160d48084ba7b5f4265d"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a52ef662dbab740fca6e0919a6dfee286a62635084e6846f5c9eaf5587cfdc5"
    sha256 cellar: :any_skip_relocation, ventura:       "9a52ef662dbab740fca6e0919a6dfee286a62635084e6846f5c9eaf5587cfdc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9a7a5e12c991f8943204b7767d0a7211ca3828a08a730a97fc6269aeb41994c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/stateful/runme/v3/internal/version.BuildDate=#{time.iso8601}
      -X github.com/stateful/runme/v3/internal/version.BuildVersion=#{version}
      -X github.com/stateful/runme/v3/internal/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"runme", "completion")
  end

  test do
    system bin/"runme", "--version"
    markdown = (testpath/"README.md")
    markdown.write <<~MARKDOWN
      # Some Markdown

      Has some text.

      ```sh { name=foobar }
      echo "Hello World"
      ```
    MARKDOWN
    assert_match "Hello World", shell_output("#{bin}/runme run --git-ignore=false foobar")
    assert_match "foobar", shell_output("#{bin}/runme list --git-ignore=false")
  end
end
