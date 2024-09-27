class Aicommit < Formula
  desc "AI-powered commit message generator"
  homepage "https://github.com/coder/aicommit"
  url "https://github.com/coder/aicommit/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "f42fac51fbe334f4d4057622b152eff168f4aa28d6da484af1cea966abd836a1"
  license "CC0-1.0"

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=v#{version}"), "./cmd/aicommit"
  end

  test do
    assert_match "aicommit v#{version}", shell_output("#{bin}/aicommit version")

    system "git", "init", "--bare", "."
    assert_match "err: $OPENAI_API_KEY is not set", shell_output("#{bin}/aicommit 2>&1", 1)
  end
end
