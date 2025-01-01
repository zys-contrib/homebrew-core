class Xc < Formula
  desc "Markdown defined task runner"
  homepage "https://xcfile.dev/"
  url "https://github.com/joerdav/xc/archive/refs/tags/v0.8.5.tar.gz"
  sha256 "374b3d4fe19355a1bc5ba63fd8bc346f027e6a1dbb04af631683ca45a24d806a"
  license "MIT"
  head "https://github.com/joerdav/xc.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/xc"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xc --version")

    (testpath/"README.md").write <<~MARKDOWN
      # Tasks

      ## hello
      ```sh
      echo "Hello, world!"
      ```
    MARKDOWN

    output = shell_output("#{bin}/xc hello")
    assert_match "Hello, world!", output
  end
end
