class Mubeng < Formula
  desc "Incredibly fast proxy checker & IP rotator with ease"
  homepage "https://github.com/kitabisa/mubeng"
  url "https://github.com/kitabisa/mubeng/archive/refs/tags/v0.15.3.tar.gz"
  sha256 "3970d542404ff25df673012280d90fef67e0be1489fd2ad429df4a9c47e5ce5e"
  license "Apache-2.0"
  head "https://github.com/kitabisa/mubeng.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "232dd50f309be0f8368f0972b195d9398118e8cb03e38f861063b7e7ecdf6633"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "232dd50f309be0f8368f0972b195d9398118e8cb03e38f861063b7e7ecdf6633"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "232dd50f309be0f8368f0972b195d9398118e8cb03e38f861063b7e7ecdf6633"
    sha256 cellar: :any_skip_relocation, sonoma:         "47d5ffb6e56594c97f5aa4979f43038cfc98a55ddd625797cf5008d53a73def4"
    sha256 cellar: :any_skip_relocation, ventura:        "47d5ffb6e56594c97f5aa4979f43038cfc98a55ddd625797cf5008d53a73def4"
    sha256 cellar: :any_skip_relocation, monterey:       "47d5ffb6e56594c97f5aa4979f43038cfc98a55ddd625797cf5008d53a73def4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "354b0490c0cf3cfacfc7c951248600f84982547f87b1638b120fce0ebbd379af"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/kitabisa/mubeng/common.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/mubeng"
  end

  test do
    expected = OS.mac? ? "no proxy file provided" : "has no valid proxy URLs"
    assert_match expected, shell_output("#{bin}/mubeng 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/mubeng --version", 1)
  end
end
