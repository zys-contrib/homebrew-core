class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.5.3",
      revision: "87f0a49fe6b0db7de0d6fa76e5d2a27963c10ca7"
  license "MIT"
  head "https://github.com/ollama/ollama.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cef9cd11a8800505c637fb5bb0fd5a2f17605475e7e296c934cfc9641db0c25f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a76c130f7965274559b10fc3df1783764740299675f63148df6de512f636f311"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f584c313be8abdc6d9fb72f5c74eda7621db2eafe253454e12269c07150d4cca"
    sha256 cellar: :any_skip_relocation, sonoma:        "9232910d06a31b461cc242ec7a73cbc59429ac791af7d23a2bcd54601b6ae741"
    sha256 cellar: :any_skip_relocation, ventura:       "dd0e15207ad75ce8741051e59bb3e4a036e22d5457be7863b9a90df4e1353783"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c1f450d105bb0aae2b9e997b42fea28e0327c549e40c30aba81e8d42f8d1881"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  def install
    # Fix to makefile path, should be checked in next release
    # https://github.com/ollama/ollama/blob/89d5e2f2fd17e03fd7cd5cb2d8f7f27b82e453d7/llama/llama.go#L3
    inreplace "llama/llama.go", "//go:generate make -j", "//go:generate make -C ../ -j"

    # Silence tens of thousands of SDK warnings
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?

    ldflags = %W[
      -s -w
      -X=github.com/ollama/ollama/version.Version=#{version}
      -X=github.com/ollama/ollama/server.mode=release
    ]

    system "go", "generate", "./..."
    system "go", "build", *std_go_args(ldflags:)
  end

  service do
    run [opt_bin/"ollama", "serve"]
    keep_alive true
    working_dir var
    log_path var/"log/ollama.log"
    error_log_path var/"log/ollama.log"
  end

  test do
    port = free_port
    ENV["OLLAMA_HOST"] = "localhost:#{port}"

    pid = fork { exec bin/"ollama", "serve" }
    sleep 3
    begin
      assert_match "Ollama is running", shell_output("curl -s localhost:#{port}")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end
