class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https://bashunit.typeddevs.com"
  url "https://github.com/TypedDevs/bashunit/releases/download/0.19.0/bashunit"
  sha256 "1579cd17f6b82131888366467ee266ed0aaffa7f2dbdbba917f904fbc91ba216"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c31823359d7c203e280c39c7efe933afc37504d370ff14c141db06d2e23a04e0"
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
