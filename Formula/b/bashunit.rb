class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https://bashunit.typeddevs.com"
  url "https://github.com/TypedDevs/bashunit/releases/download/0.19.1/bashunit"
  sha256 "2d085bcb752a9b910db7a964b309a25960a19e778f40676ff51d9d7534891a48"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7432159a56d3ebc5b4dbb3b48f1b842405964ad29b2b2d968547886a7c5f5e46"
  end

  def install
    bin.install "bashunit"
  end

  test do
    (testpath/"test.sh").write <<~SHELL
      function test_addition() {
        local result
        result="$((2 + 2))"

        assert_equals "4" "$result"
      }
    SHELL
    assert "addition", shell_output("#{bin}/bashunit test.sh")

    assert_match version.to_s, shell_output("#{bin}/bashunit --version")
  end
end
