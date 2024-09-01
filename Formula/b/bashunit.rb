class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https://bashunit.typeddevs.com"
  url "https://github.com/TypedDevs/bashunit/releases/download/0.15.0/bashunit"
  sha256 "a201257512fe99e10016e223f21f9ae5689627016856729462a597306474f7a3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2c1cd9ea8bd47d5520162c447e793b0920f17088611493f14a0a1b2a63c6c35a"
  end

  def install
    bin.install "bashunit"
  end

  test do
    (testpath/"test.sh").write <<~EOS
      function test_addition() {
        local result
        result="$((2 + 2))"

        assert_equals "4" "$result"
      }
    EOS
    assert "addition", shell_output("#{bin}/bashunit test.sh")

    assert_match version.to_s, shell_output("#{bin}/bashunit --version")
  end
end
