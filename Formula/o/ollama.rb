class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.2.3",
      revision: "22c5451fc28b20dd83a389c49d9caf6a1e50a9e3"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a472207612ab8a7dadce426e8f041840deb3d86ada963b973ea5848b0a3a294b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "959ea4066a3978e89419a225af4efbd2deb67c237eac2d0862083d63572279c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "adac9a328b6235b7b0d3057b9142eeef8f20b5474d7742b9109f369b7e9e5a89"
    sha256 cellar: :any_skip_relocation, sonoma:         "f0dcfb62c32bd5c774f0c1337872dea5b20afdae0205a0c9f1d518d965a0be82"
    sha256 cellar: :any_skip_relocation, ventura:        "44328a753b27e45317f2c922f70cad4b7b770cea4d2911ae4367f183c35a21d3"
    sha256 cellar: :any_skip_relocation, monterey:       "5381065e673760af1e26148e340eea858c29a8a12357cdfb9f37596f4a809052"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45ddaab68cf01f7c962bad996fc02aef957580c0f15c4101f6b55c74f6d3850b"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  def install
    # Fix build by setting SDKROOT
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?
    # Fix "ollama --version"
    inreplace "version/version.go", /var Version string = "[\d.]+"/, "var Version string = \"#{version}\""

    system "go", "generate", "./..."
    system "go", "build", *std_go_args(ldflags: "-s -w")
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

    pid = fork { exec "#{bin}/ollama", "serve" }
    sleep 3
    begin
      assert_match "Ollama is running", shell_output("curl -s localhost:#{port}")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end
