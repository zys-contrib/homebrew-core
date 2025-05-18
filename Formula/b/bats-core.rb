class BatsCore < Formula
  desc "Bash Automated Testing System"
  homepage "https://github.com/bats-core/bats-core"
  url "https://github.com/bats-core/bats-core/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "e36b020436228262731e3319ed013d84fcd7c4bd97a1b34dee33d170e9ae6bab"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "28949c0596b90bc8604d4f530e2e4a1e3c81c63b5a92ce2ecf187abb06169723"
  end

  depends_on "coreutils"

  uses_from_macos "bc" => :test

  def install
    system "./install.sh", prefix
  end

  test do
    (testpath/"test.sh").write <<~SHELL
      @test "addition using bc" {
        result="$(echo 2+2 | bc)"
        [ "$result" -eq 4 ]
      }
    SHELL
    assert_match "addition", shell_output("#{bin}/bats test.sh")
  end
end
