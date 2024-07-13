class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.2.2",
      revision: "e5c65a85df21a78052bb9f46bdb37bf6838644f7"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2c7eaec40cc281384b66be0defd0fe38a358adbca25db2097017b246b309ccae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e844b506e171fb9cf40f08c0ccdb42aefe2eeb155f508f864947f8d5105384a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39bd74d153fb3e90bb4fa79c1ba65b3842bccb866b43881fa6eb5f08d10536ed"
    sha256 cellar: :any_skip_relocation, sonoma:         "10496c88250930ae5805955c26f38dd99b330f943dab2842d007ad6fdd123acd"
    sha256 cellar: :any_skip_relocation, ventura:        "2741b378fe5a3970d3602bfcab6dc4348e1d65c5635d272d187521f14722abd9"
    sha256 cellar: :any_skip_relocation, monterey:       "670a4ddfd24972d407536458a0b1e47275442ae4f7115f91daa81b0ff65ed41e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "277aed408e742080c52b9c34a67b5bf3366e974627ccd166a737578619388f4e"
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
