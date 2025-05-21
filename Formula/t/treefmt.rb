class Treefmt < Formula
  desc "One CLI to format the code tree"
  homepage "https://treefmt.com/latest/"
  url "https://github.com/numtide/treefmt/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "02d29561b92110e83596ec93e19c8787b31f4b3211bd0a9d2c384d1b09f74c94"
  license "MIT"
  head "https://github.com/numtide/treefmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdee84110d11c4f97a21070b1cb58fcd590602750c7407d0b7bafbd3354d9133"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdee84110d11c4f97a21070b1cb58fcd590602750c7407d0b7bafbd3354d9133"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fdee84110d11c4f97a21070b1cb58fcd590602750c7407d0b7bafbd3354d9133"
    sha256 cellar: :any_skip_relocation, sonoma:        "a50e7012dde0038a99f736a37d3fb630af8ad3dd9144847e169ffda761921d98"
    sha256 cellar: :any_skip_relocation, ventura:       "a50e7012dde0038a99f736a37d3fb630af8ad3dd9144847e169ffda761921d98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4149e3244d3b7f865eff027723a42efd93d609645e06839cd0d3dff4860103f7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/numtide/treefmt/v2/build.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/treefmt 2>&1", 1)
    assert_match "failed to find treefmt config file: could not find [treefmt.toml .treefmt.toml]", output
    assert_match version.to_s, shell_output("#{bin}/treefmt --version")
  end
end
