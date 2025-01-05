class Vgt < Formula
  desc "Visualising Go Tests"
  homepage "https://github.com/roblaszczak/vgt"
  url "https://github.com/roblaszczak/vgt/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "1db7e7d9c2e2d0b4c5c6f33a71b4e13142a20319238f7d47166fea68919488c5"
  license "MIT"
  head "https://github.com/roblaszczak/vgt.git", branch: "main"

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"test.go").write <<~EOS
      package test

      import "testing"

      func TestExample(t *testing.T) {
        t.Log("Hello from sample test")
      }
    EOS

    output = pipe_output("#{bin}/vgt --print-html", "go test -json #{testpath}/sample_test.go", 0)
    assert_match "Test Results (0s 0 passed, 0 failed)", output
  end
end
