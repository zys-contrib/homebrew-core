class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://render.com/docs/cli"
  url "https://github.com/render-oss/cli/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "3f7cd5a46ee79e0e450b88bc07794ffa535c5b0faa661f611d5ccf7bfd6e4815"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b36becb41418a39165bbb06fa21d1a47eff1ee7f8259f85fef281bfcf531b0fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b36becb41418a39165bbb06fa21d1a47eff1ee7f8259f85fef281bfcf531b0fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b36becb41418a39165bbb06fa21d1a47eff1ee7f8259f85fef281bfcf531b0fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c5cb83b0cf4c49ef867a8fe7bea466b885a04ab5a824c1918fff5a59e1716c0"
    sha256 cellar: :any_skip_relocation, ventura:       "7c5cb83b0cf4c49ef867a8fe7bea466b885a04ab5a824c1918fff5a59e1716c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "400efede4482ea042ec9c39016fc6955fa98878970f4d085f75258d227262f94"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/render-oss/cli/pkg/cfg.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    error_msg = "Error: run `render login` to authenticate"
    assert_match error_msg, shell_output("#{bin}/render services -o json 2>&1", 1)
  end
end
