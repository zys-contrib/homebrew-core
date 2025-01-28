class Chkbit < Formula
  desc "Check your files for data corruption"
  homepage "https://github.com/laktak/chkbit"
  url "https://github.com/laktak/chkbit/archive/refs/tags/v6.1.0.tar.gz"
  sha256 "d05a1c8435e58b4b85f649f06b3c9303e0c9c79cb202acd958607f60f57924e2"
  license "MIT"
  head "https://github.com/laktak/chkbit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fe4ae3efb036d5984afc0e5625db944845e384f3d60c5b0304c963741d099a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fe4ae3efb036d5984afc0e5625db944845e384f3d60c5b0304c963741d099a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6fe4ae3efb036d5984afc0e5625db944845e384f3d60c5b0304c963741d099a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4a9f1d1ffd0637734bf2697fd31021d38ef7190e0ba7fd289d18ae1b10ed3ae"
    sha256 cellar: :any_skip_relocation, ventura:       "d4a9f1d1ffd0637734bf2697fd31021d38ef7190e0ba7fd289d18ae1b10ed3ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0729bbe46dbe771ec0549789f68e70c54d1577150ded12801a6ca3e6654c0e78"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.appVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/chkbit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chkbit version").chomp
    system bin/"chkbit", "init", "split", testpath
    assert_predicate testpath/".chkbit", :exist?
  end
end
