class Slackdump < Formula
  desc "Export Slack data without admin privileges"
  homepage "https://github.com/rusq/slackdump"
  url "https://github.com/rusq/slackdump/archive/refs/tags/v2.5.10.tar.gz"
  sha256 "813c282b3fe64f9c75ae911af85a8524ccb241b0e73a45d23a4f222622531d43"
  license "GPL-3.0-only"
  head "https://github.com/rusq/slackdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "60f59c95b43afa78b11b248e5a966c1e396e371250966418454ad90956963645"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60f59c95b43afa78b11b248e5a966c1e396e371250966418454ad90956963645"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60f59c95b43afa78b11b248e5a966c1e396e371250966418454ad90956963645"
    sha256 cellar: :any_skip_relocation, sonoma:         "cc7bb533148c2ada79d1935bc7b1ce85113a73254e69dcb88c5463dd006c0130"
    sha256 cellar: :any_skip_relocation, ventura:        "cc7bb533148c2ada79d1935bc7b1ce85113a73254e69dcb88c5463dd006c0130"
    sha256 cellar: :any_skip_relocation, monterey:       "cc7bb533148c2ada79d1935bc7b1ce85113a73254e69dcb88c5463dd006c0130"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f72a051d2309351af0cc9f9c86a8907b586d48f1c8cb532efe78887f3965e1d7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
      -X main.commit=Homebrew
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/slackdump"
  end

  test do
    assert_match version.to_s, shell_output(bin/"slackdump -V")

    assert_match "You have been logged out.", shell_output(bin/"slackdump -auth-reset 2>&1")
  end
end
