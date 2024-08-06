class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.25.2.tar.gz"
  sha256 "8f6e44109be12924ec6cca073c9eb9d51ed9c7c2384eb71622d2085a2d558ade"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ae1df447fc112f8ecee44d432e7af2ca81ae925715d715a7e5951f0e785782ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae1df447fc112f8ecee44d432e7af2ca81ae925715d715a7e5951f0e785782ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae1df447fc112f8ecee44d432e7af2ca81ae925715d715a7e5951f0e785782ec"
    sha256 cellar: :any_skip_relocation, sonoma:         "93cb98b2690e206d3b7944677bc0e952230483d1bd4511fa1e6f1c5f85b61f72"
    sha256 cellar: :any_skip_relocation, ventura:        "93cb98b2690e206d3b7944677bc0e952230483d1bd4511fa1e6f1c5f85b61f72"
    sha256 cellar: :any_skip_relocation, monterey:       "2e1ce769e62625fcdd965320a082e73f53e7a01e386a13588f042c87e16e27c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69956481dd8dd19339c03cb987034e60487750305c846297f971efe9254dbfeb"
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
