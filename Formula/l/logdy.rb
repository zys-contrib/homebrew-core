class Logdy < Formula
  desc "Web based real-time log viewer"
  homepage "https://logdy.dev"
  url "https://github.com/logdyhq/logdy-core/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "8ab02af3ad7e98006d86c27d4cc649063b4809d831445aad3028f2bbcc46ba1b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4484a77d5af10c4430614b626dc544a16070e6aef847480e328125002bb5298e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4484a77d5af10c4430614b626dc544a16070e6aef847480e328125002bb5298e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4484a77d5af10c4430614b626dc544a16070e6aef847480e328125002bb5298e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9b90e04949805725a7343ea2990e17c9efdf17b828a014f886ae7bdf44115cd"
    sha256 cellar: :any_skip_relocation, ventura:       "b9b90e04949805725a7343ea2990e17c9efdf17b828a014f886ae7bdf44115cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a4c17d360ebeec5f2ba0609c752d5b5f3efee5aa5811c28a2d63808fb31215c"
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
