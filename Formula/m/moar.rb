class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.31.8.tar.gz"
  sha256 "77943278d1ca22c3ca405c6a227e4807ce8637b807c40802c739f901ae980151"
  license "BSD-2-Clause"
  head "https://github.com/walles/moar.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65dc6cf60208f5cd6bfae37327db2ab632a4d15ffc1b79b90474f8cf8ed6d1c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65dc6cf60208f5cd6bfae37327db2ab632a4d15ffc1b79b90474f8cf8ed6d1c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "65dc6cf60208f5cd6bfae37327db2ab632a4d15ffc1b79b90474f8cf8ed6d1c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3a3bcad45fd3b967c25477e5e3902908b8566e128e6d399ed45b8dfdfe96f2b"
    sha256 cellar: :any_skip_relocation, ventura:       "f3a3bcad45fd3b967c25477e5e3902908b8566e128e6d399ed45b8dfdfe96f2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3fee774d9ab17c0b8df6025e8605390ee396739ac685019ef162af760e68b87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70bf3b43ad071dfc30190b7b5bd336267856edc788ad286d611482f700f1a4c5"
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
