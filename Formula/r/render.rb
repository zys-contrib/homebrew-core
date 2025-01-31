class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://github.com/render-oss/cli"
  url "https://github.com/render-oss/cli/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "c68166aab1f2160be2ad7662e9174498235d5a345d54c6a0588a3ac835dcc5ea"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba1a213243d78fbc83f050e98c028a4949c14755fa70549046d1c8686ab75ead"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba1a213243d78fbc83f050e98c028a4949c14755fa70549046d1c8686ab75ead"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ba1a213243d78fbc83f050e98c028a4949c14755fa70549046d1c8686ab75ead"
    sha256 cellar: :any_skip_relocation, sonoma:        "597918a4eac08712ab8003048ff1e84408e9b484dff00fe691504849a18215fa"
    sha256 cellar: :any_skip_relocation, ventura:       "597918a4eac08712ab8003048ff1e84408e9b484dff00fe691504849a18215fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdc3915c26e55c642ffefef301e2c31f238666955a896dbab5efe56f66efacda"
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
