class KubectlAi < Formula
  desc "AI powered Kubernetes Assistant"
  homepage "https://github.com/GoogleCloudPlatform/kubectl-ai"
  url "https://github.com/GoogleCloudPlatform/kubectl-ai/archive/refs/tags/v0.0.14.tar.gz"
  sha256 "e84e7f7d569f2119d359e2cef923a05c7dc4265fb9d7dda8122fe552ff289978"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee951ecc463306bc5298c19326e8df1613a33b37581c9daab1b700686d7b7b9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee951ecc463306bc5298c19326e8df1613a33b37581c9daab1b700686d7b7b9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ee951ecc463306bc5298c19326e8df1613a33b37581c9daab1b700686d7b7b9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "85e752dcafc243778426fe66c57b861897212a21b61c547003e0008bf1ab83da"
    sha256 cellar: :any_skip_relocation, ventura:       "85e752dcafc243778426fe66c57b861897212a21b61c547003e0008bf1ab83da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b9eec60ceb40e87e250b256ce7413a167b93984ac3142997cfcb381330af256"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd"

    generate_completions_from_executable(bin/"kubectl-ai", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubectl-ai version")

    ENV["GEMINI_API_KEY"] = "test"
    PTY.spawn(bin/"kubectl-ai", "--llm-provider", "gemini") do |r, w, pid|
      sleep 1
      w.puts "test"
      sleep 1
      output = r.read_nonblock(1024)
      assert_match "Hey there, what can I help you with", output
    rescue Errno::EIO
      # End of input, ignore
    ensure
      Process.kill("TERM", pid)
    end
  end
end
