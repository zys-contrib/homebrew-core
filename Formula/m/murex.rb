class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://github.com/lmorg/murex/archive/refs/tags/v6.4.0373.tar.gz"
  sha256 "53a0975534ba478ddf824412ccf2b3ebee3ccff01a280247f5cc0c6ddce8500b"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed02887901e870db9f95c79268922b5ac1bc9903cfd92624d64ea12092b47321"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed02887901e870db9f95c79268922b5ac1bc9903cfd92624d64ea12092b47321"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed02887901e870db9f95c79268922b5ac1bc9903cfd92624d64ea12092b47321"
    sha256 cellar: :any_skip_relocation, sonoma:        "53f709e6aa6c221de8fb48aa73a36e86a19fe438d9a46002cfd885e3183cde1c"
    sha256 cellar: :any_skip_relocation, ventura:       "53f709e6aa6c221de8fb48aa73a36e86a19fe438d9a46002cfd885e3183cde1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53a5069937142d85262064688c679db11eddf92e9073b68dbded9c16b4fd2fe3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_equal "homebrew", shell_output("#{bin}/murex -c 'echo homebrew'").chomp
    assert_match version.to_s, shell_output("#{bin}/murex -version")
  end
end
