class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https://smcleod.net"
  url "https://github.com/sammcj/gollama/archive/refs/tags/v1.32.1.tar.gz"
  sha256 "d9af32b9c8c3924358fb58bf97c186f8a547172194d8b171fbda7e33a2618d40"
  license "MIT"
  head "https://github.com/sammcj/gollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c80a01f450c7ff445f63bd312f7c09ebea9e1edbd5a5bd8ac0cae68b3962ecf0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7564e279d98c259dfc285d8cbaaa2e8b6a784c0280b0ef0c5208e2a3dceeb98b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7344f2faf9cf6963ee1c8da8b01ccf3be3d8e20675862523cb085b26847efa9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "40ee2f88ba0d6bf4a28d341665e068b3f88213edafa39854de78bc8cf41dab08"
    sha256 cellar: :any_skip_relocation, ventura:       "2e7fab5982232e65fb73a9e0d98d36c1fd3842100a1aefa0ea4566b3a5c4d945"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a7f708a866d940045d4d1801c7b6413e9a375975ec5a19539d50bf8f460c4fd"
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
