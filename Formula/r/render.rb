class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://github.com/render-oss/cli"
  url "https://github.com/render-oss/cli/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "bbc1a37e541c2bbfcb96bbff043fe4f9bcb1e80c70a5224639f1e0a99c0e2cc1"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

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
