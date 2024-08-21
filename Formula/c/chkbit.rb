class Chkbit < Formula
  desc "Check your files for data corruption"
  homepage "https://github.com/laktak/chkbit"
  url "https://github.com/laktak/chkbit/archive/refs/tags/v5.1.2.tar.gz"
  sha256 "08b52d40a9df13d4f194d7b633c69960bf5d78279414ff064170f63dcdcb062e"
  license "MIT"
  head "https://github.com/laktak/chkbit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c4b2a26fd885c5b0cbd1cdfffaf687a1aaf5c5938ea277e57fdd679933e9e7a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4b2a26fd885c5b0cbd1cdfffaf687a1aaf5c5938ea277e57fdd679933e9e7a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4b2a26fd885c5b0cbd1cdfffaf687a1aaf5c5938ea277e57fdd679933e9e7a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "53f2b2781143378af5ba372b2592d3c33efcacfadb41d338405bc53375a4e94b"
    sha256 cellar: :any_skip_relocation, ventura:        "53f2b2781143378af5ba372b2592d3c33efcacfadb41d338405bc53375a4e94b"
    sha256 cellar: :any_skip_relocation, monterey:       "53f2b2781143378af5ba372b2592d3c33efcacfadb41d338405bc53375a4e94b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8974126bed326d09096b83b39ba516d9b9dcc725a2925df75884a70c7818fe5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.appVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/chkbit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chkbit --version").chomp

    (testpath/"one.txt").write <<~EOS
      testing
      testing
      testing
    EOS

    system bin/"chkbit", "-u", testpath
    assert_predicate testpath/".chkbit", :exist?
  end
end
