class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https://smcleod.net"
  url "https://github.com/sammcj/gollama/archive/refs/tags/v1.28.4.tar.gz"
  sha256 "4f77dec51e9c3725d7286ca0b90d8cc4a7472005103a375c39befc93ed2271e8"
  license "MIT"
  head "https://github.com/sammcj/gollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b422f146a0d3966a2c9b5fd1bf7c4487bf8f685f2ae7643ab76330f30728a4dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35ad5d2823217aedf53fb2483f9b821737760248be1b4c5fe7e9e94e7267a4df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d81f905a147902b39938870ead76c98d4ced72e957f66a8662368209bcb3001"
    sha256 cellar: :any_skip_relocation, sonoma:        "659baf111d3e3a3ff5b083f02ff576c65fbcf1c86b19148c9139b9b681c45f0d"
    sha256 cellar: :any_skip_relocation, ventura:       "a20b0e8a9473db0248599bc02fe38d4e17fc7b28eb3c8e9eed0c9ed201e8dad7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c51fa8f08309f84dbd0d319c0cd6e3268c6c91c16a4c46f71f5a903748e9efb"
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
