class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https://smcleod.net"
  url "https://github.com/sammcj/gollama/archive/refs/tags/v1.27.6.tar.gz"
  sha256 "88c027874b85f6e00b8b421bfe5789c21be6ee1b8ec529f0393a9f682bd9fd65"
  license "MIT"
  head "https://github.com/sammcj/gollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20cb6d06a6466e805f1f800ae92505671d6ae6c7b6c860eb748c56bf8c752825"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6013577ddf7e235680070e0e45126fbae18317dd241484670c2e68a558bfa2b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b386a727b4f4f1add741769a3082beadf6bf594693677a0cd56e3c5569319b9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b394ddd6ae2b43fbe6e36732575787bcef0a400823cf42ebc994457cdcb2d533"
    sha256 cellar: :any_skip_relocation, ventura:       "c352fa1b02587209943ea08f494b891ded9ada6c5ccaf6e7949fc942449a339e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72481b49e9108fdc16006912160a6965f776219c8470a6cbb19493674f1b58d5"
  end

  depends_on "go" => :build
  depends_on "ollama" => :test

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output(bin/"gollama -v")

    port = free_port
    ENV["OLLAMA_HOST"] = "localhost:#{port}"

    pid = fork { exec "#{Formula["ollama"].opt_bin}/ollama", "serve" }
    sleep 3
    begin
      assert_match "No matching models found.",
        shell_output(bin/"gollama -h http://localhost:#{port} -s chatgpt")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end
