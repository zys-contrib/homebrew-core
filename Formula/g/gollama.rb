class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https://smcleod.net"
  url "https://github.com/sammcj/gollama/archive/refs/tags/v1.29.0.tar.gz"
  sha256 "a1b87d30478b8a61f7ca0b0b1a580d5084e65c5930e47a3b79fbc949c3cace35"
  license "MIT"
  head "https://github.com/sammcj/gollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cebe90c5b57e989b726ac58fa5450ce42d869debfa9f9dd6c5b506a0d5184c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e46e45f3ef75bc2c678fe75bbbb0ff78a36c93929ee0a341c10da6653f455ed7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "886c4ca6da85e6f373f6f0700c4de3f3c82fc254bef30d393885cc71657cb53b"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a9ee324d31de45d7717afc80b247623481df8fb4e76cbccf53f6269b13c515f"
    sha256 cellar: :any_skip_relocation, ventura:       "d72f64eb2ba070857b76338cde9118c6ed9f6b65f61565852343c54747aca6c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff8979e678bd1bcf35868585cf0cc9ef512aab009c1a32e7bdb8fabaac5ab3bc"
  end

  depends_on "go" => :build
  depends_on "ollama" => :test

  def install
    system "go", "mod", "tidy"

    ldflags = "-s -w -X main.Version=#{version}"
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
