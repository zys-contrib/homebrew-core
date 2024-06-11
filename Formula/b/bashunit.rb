class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https://bashunit.typeddevs.com"
  url "https://github.com/TypedDevs/bashunit/releases/download/0.12.0/bashunit"
  sha256 "c968376996fd78d346171c585e1d3f7fcc62b7b8e2b9c4f472072ee72da04683"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4370c2c0383e64467bf2bbd71cb0380c45170bd209a29230d3d7370b4f9e9e04"
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
