class Doggo < Formula
  desc "Command-line DNS Client for Humans"
  homepage "https://doggo.mrkaran.dev/"
  url "https://github.com/mr-karan/doggo/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "d63947f3f944be319bb1ae6438d2cde5b923d796b544403fb3905e0460864385"
  license "GPL-3.0-or-later"
  head "https://github.com/mr-karan/doggo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "42d0acacbd17caac6893be27553e2b3a2073409134482fe0f2fb6c448954001a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a1f3c72e74d7690ffe0e1b9c9ee2b55fd69fb46a3445345171559d6ef569c42"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33cedbb7407392ccf307bbdac09d51a53623f657ff94479d89d7306f206cf13a"
    sha256 cellar: :any_skip_relocation, sonoma:         "0c59a35c34c50dc8e646963386df207798a94d58dd28930f94293a0e70a43404"
    sha256 cellar: :any_skip_relocation, ventura:        "0c13a5167e684660ff6de1357a29f6839f8047eae8b020374c8b6ac41727bcac"
    sha256 cellar: :any_skip_relocation, monterey:       "c35e33fe3edb8c15b85df3e1f61fc1d69296ac7820432dc734beb7a773bde75f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "811500996d8d721b0934122a7de05905355f8c41ff739ed771e05ba6bcf42b43"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.buildVersion=#{version} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/doggo"

    generate_completions_from_executable(bin/"doggo", "completions")
  end

  test do
    answer = shell_output("#{bin}/doggo --short example.com NS @1.1.1.1")
    assert_equal "a.iana-servers.net.\nb.iana-servers.net.\n", answer

    assert_match version.to_s, shell_output("#{bin}/doggo --version")
  end
end
