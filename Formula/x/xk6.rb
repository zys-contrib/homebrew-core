class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https://k6.io"
  url "https://github.com/grafana/xk6/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "d3da50e3491b889bc8f86718bd13d7cc658c5414a94db8d1d05cc6fefd94a8df"
  license "Apache-2.0"
  head "https://github.com/grafana/xk6.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2560adfdcd7e7a89a49a29444c369a2d16f60057a8d6b224f19bf2e8686b1147"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2560adfdcd7e7a89a49a29444c369a2d16f60057a8d6b224f19bf2e8686b1147"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2560adfdcd7e7a89a49a29444c369a2d16f60057a8d6b224f19bf2e8686b1147"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb7ff607339030f947cf90c8d58a2dc786831e7b94d22bab730698c2d5887f3e"
    sha256 cellar: :any_skip_relocation, ventura:       "bb7ff607339030f947cf90c8d58a2dc786831e7b94d22bab730698c2d5887f3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55ad8aa5decacad6423bd22b41e20c2a350307807db7ffa62b0d1fcdcd82359d"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/xk6"
  end

  test do
    str_build = shell_output("#{bin}/xk6 build")
    assert_match "xk6 has now produced a new k6 binary", str_build
  end
end
