class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/refs/tags/v0.47.0.tar.gz"
  sha256 "0e2240508bd317811a7cfba774d3378e2a3527e1685bcb0bf4cf0d227f191e68"
  license "MIT"
  head "https://github.com/jesseduffield/lazygit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b2e7c5e2e053030934e78551a6232be46955a7d23c3f028722c552a2a5b5d26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b2e7c5e2e053030934e78551a6232be46955a7d23c3f028722c552a2a5b5d26"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b2e7c5e2e053030934e78551a6232be46955a7d23c3f028722c552a2a5b5d26"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f44a9aa8512c641bc50323aa4dd07489f11dd406210c004b3ae0cd3030c23af"
    sha256 cellar: :any_skip_relocation, ventura:       "7f44a9aa8512c641bc50323aa4dd07489f11dd406210c004b3ae0cd3030c23af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8d065f5cd45fd56a20eb962cd9c91766ee87721fb6faf82e438c82565ba0c33"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.buildSource=homebrew"
    system "go", "build", "-mod=vendor", *std_go_args(ldflags:)
  end

  test do
    system "git", "init", "--initial-branch=main"

    output = shell_output("#{bin}/lazygit log 2>&1", 1)
    assert_match "errors.errorString terminal not cursor addressable", output

    assert_match version.to_s, shell_output("#{bin}/lazygit -v")
  end
end
