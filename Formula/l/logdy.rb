class Logdy < Formula
  desc "Web based real-time log viewer"
  homepage "https://logdy.dev"
  url "https://github.com/logdyhq/logdy-core/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "93ac3553c8d3bfa2dade1a5225a6f13d3ea99a8e45caec461228d6f16a6b2a87"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38634f61a179cc18189024802a6fc2ac62862892974caabd80ba350d3a4b5d3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38634f61a179cc18189024802a6fc2ac62862892974caabd80ba350d3a4b5d3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "38634f61a179cc18189024802a6fc2ac62862892974caabd80ba350d3a4b5d3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd989e0d0dfd03fb13c5ed2ea7180c1f7b06131006a33032b4e4bade625c6809"
    sha256 cellar: :any_skip_relocation, ventura:       "cd989e0d0dfd03fb13c5ed2ea7180c1f7b06131006a33032b4e4bade625c6809"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "806e394f11925a1b278f9a76b23e325ab09f158fe07fcce619cb572a53dc225d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"logdy", "completion")
  end

  test do
    port = free_port
    r, _, pid = PTY.spawn("#{bin}/logdy stdin --port=#{port}")
    assert_match "Listen to stdin (from pipe)", r.readline
  ensure
    Process.kill("TERM", pid)
  end
end
