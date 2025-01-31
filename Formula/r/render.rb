class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://github.com/render-oss/cli"
  url "https://github.com/render-oss/cli/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "0a9da315b0d5563460161228c0b882ae599936f22774f517c61369029877d5ab"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d55427dff8a5bde46fff9d3c47d313fb0981e6cb6904a6deaf3e6ac6a919ae5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d55427dff8a5bde46fff9d3c47d313fb0981e6cb6904a6deaf3e6ac6a919ae5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d55427dff8a5bde46fff9d3c47d313fb0981e6cb6904a6deaf3e6ac6a919ae5"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee973851254342c657992d481fa5957516bbe73c94b06c85cc2163fbbb5e0876"
    sha256 cellar: :any_skip_relocation, ventura:       "ee973851254342c657992d481fa5957516bbe73c94b06c85cc2163fbbb5e0876"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55a768398bfd1e2bd39fbb843f2175b25dc4f9144d3de5e42119af7e6e68e628"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/renderinc/cli/pkg/cfg.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    error_msg = "Error: run `render login` to authenticate"
    assert_match error_msg, shell_output("#{bin}/render services -o json 2>&1", 1)
  end
end
