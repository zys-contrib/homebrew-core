class Yeet < Formula
  desc "Packaging tool that lets you declare build instructions in JavaScript"
  homepage "https://github.com/TecharoHQ/yeet"
  url "https://github.com/TecharoHQ/yeet/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "b87d344b56eb69aa72dce54c88397a77a8a24a9c013d1d81796d165d3000fe5d"
  license "MIT"
  head "https://github.com/TecharoHQ/yeet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34f2d0c180c1e05652d8d5aa8e43dfc28f0cbe9e05d17c410a759a1150ee283a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34f2d0c180c1e05652d8d5aa8e43dfc28f0cbe9e05d17c410a759a1150ee283a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "34f2d0c180c1e05652d8d5aa8e43dfc28f0cbe9e05d17c410a759a1150ee283a"
    sha256 cellar: :any_skip_relocation, sonoma:        "2490122d86e7754143fbcdb52bbc476db589a583109a0dc059c6337b3dadb770"
    sha256 cellar: :any_skip_relocation, ventura:       "2490122d86e7754143fbcdb52bbc476db589a583109a0dc059c6337b3dadb770"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e59fabc9271cf3964d26fe4fea28c7f25becbea8ad974e53dd73c270c06dfca7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/TecharoHQ/yeet.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/yeet"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yeet -version")

    output = "open yeetfile.js: no such file or directory"
    assert_match output, shell_output("#{bin}/yeet 2>&1", 1)
  end
end
