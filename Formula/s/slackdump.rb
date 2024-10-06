class Slackdump < Formula
  desc "Export Slack data without admin privileges"
  homepage "https://github.com/rusq/slackdump"
  url "https://github.com/rusq/slackdump/archive/refs/tags/v2.5.14.tar.gz"
  sha256 "81319c48fa5e202a873792ff772158a0fad6634236a0ebbce945d0bda988fd72"
  license "GPL-3.0-only"
  head "https://github.com/rusq/slackdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbaa32b00f147a4de223ba06d68a5833b4b7fbe1b321f88b8d2a23499c582c61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbaa32b00f147a4de223ba06d68a5833b4b7fbe1b321f88b8d2a23499c582c61"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bbaa32b00f147a4de223ba06d68a5833b4b7fbe1b321f88b8d2a23499c582c61"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e66019a0559be94ad98ba17de2647a3d4fe44d49620a8732dff211cfb0e3e50"
    sha256 cellar: :any_skip_relocation, ventura:       "3e66019a0559be94ad98ba17de2647a3d4fe44d49620a8732dff211cfb0e3e50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1de375b9bb82a8e22b5c7d95cf1f367b2d6c01742ac178de84d2abfab1f189dc"
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
