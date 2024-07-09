class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.2.0",
      revision: "53da2c69654769c0c086af695722e1d9b9ee6ecc"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b2030357577820ab67b3617f24421775abba0fbfe380af1b5c6f9c4e55ef5f41"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ad1d18a61ec987ad670ca79e538f62a1d6e97f110733647906b22da26a2e7ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9eef2677e4514e6297ce3a49225dba1486a607b93466ab2e3d7ce39fb6dbacfd"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c12622a45ed0f8cdbaca33306fdd6c7695c4025f41724d40d5454ff15abd0ee"
    sha256 cellar: :any_skip_relocation, ventura:        "b18824ada77bfaca18036165d64e5c4fd44914358eb733b103839c2270cb35ea"
    sha256 cellar: :any_skip_relocation, monterey:       "71e640fe66649bdad1da97c1637a3764832731710f17764e96128d6504344100"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4de18aa996527e202bafd87d8bdafe512f08f006aa3193fe6082dde8778a039"
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
