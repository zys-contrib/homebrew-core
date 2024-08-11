class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.25.4.tar.gz"
  sha256 "908395f560d2dc60b1b29c0fc1ed3b0f43ab6cc527ff3ae645f4e8e4c44f6ecf"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3ced71c452b9e5e68f1b899b1e6a424cb89c4c8b25b826ecaa07004ddb2c979d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ced71c452b9e5e68f1b899b1e6a424cb89c4c8b25b826ecaa07004ddb2c979d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ced71c452b9e5e68f1b899b1e6a424cb89c4c8b25b826ecaa07004ddb2c979d"
    sha256 cellar: :any_skip_relocation, sonoma:         "82a92fcdedbc74e6c07a691216c9345e9333b0dfbf619bf8dfb0ad44fe9662d4"
    sha256 cellar: :any_skip_relocation, ventura:        "82a92fcdedbc74e6c07a691216c9345e9333b0dfbf619bf8dfb0ad44fe9662d4"
    sha256 cellar: :any_skip_relocation, monterey:       "82a92fcdedbc74e6c07a691216c9345e9333b0dfbf619bf8dfb0ad44fe9662d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d88919ce43ef5abe0938aa3e163eb325cfe468b02497eecd1a00ddd95342a830"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
    man1.install "moar.1"
  end

  test do
    # Test piping text through moar
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moar test.txt").strip
  end
end
