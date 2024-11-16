class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.29.0.tar.gz"
  sha256 "a3e91b021e8b5d8546c1b0b31a0750396c05488ea2eafd57c2e1b312daa62d91"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a897358bedc1fda2b8be6174de7ad350da734292b05d05a47e3969c7ee6e5fe2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a897358bedc1fda2b8be6174de7ad350da734292b05d05a47e3969c7ee6e5fe2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a897358bedc1fda2b8be6174de7ad350da734292b05d05a47e3969c7ee6e5fe2"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c78c766820770c31c2da25711f04df027d70985cca2a921ea560d442d00171a"
    sha256 cellar: :any_skip_relocation, ventura:       "4c78c766820770c31c2da25711f04df027d70985cca2a921ea560d442d00171a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f225f5461f4677f6a3720a93603eb1cfe21d7887e6cdcb57ddb66fa6e13d8a5d"
  end

  depends_on "go" => :build

  conflicts_with "moarvm", "rakudo-star", because: "both install `moar` binaries"

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
