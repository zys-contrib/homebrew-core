class Wgo < Formula
  desc "Watch arbitrary files and respond with arbitrary commands"
  homepage "https://github.com/bokwoon95/wgo"
  url "https://github.com/bokwoon95/wgo/archive/refs/tags/v0.5.10.tar.gz"
  sha256 "acb42473d5deae4d8547d65d9883b4f1078f4eb5d6685947d48b0e86e67c29e9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79d2284328fac85aba25665f145a7cb00fdc6682e947dbe5b53ebaaa4a474e82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79d2284328fac85aba25665f145a7cb00fdc6682e947dbe5b53ebaaa4a474e82"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "79d2284328fac85aba25665f145a7cb00fdc6682e947dbe5b53ebaaa4a474e82"
    sha256 cellar: :any_skip_relocation, sonoma:        "a60b2425c23d392f383d74be726721392eae17f7ff74ebea52b5e5116995c467"
    sha256 cellar: :any_skip_relocation, ventura:       "a60b2425c23d392f383d74be726721392eae17f7ff74ebea52b5e5116995c467"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2dcea8ece21d782265432ecd2a8484d527eff5023f08565d072593b6e81c34e5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/wgo -exit echo testing")
    assert_match "testing", output
  end
end
