class KubectlAi < Formula
  desc "AI powered Kubernetes Assistant"
  homepage "https://github.com/GoogleCloudPlatform/kubectl-ai"
  url "https://github.com/GoogleCloudPlatform/kubectl-ai/archive/refs/tags/v0.0.7.tar.gz"
  sha256 "594bf9333e39b4c9e7292bbb4d27c7eee932efb5d11da59b684ec9953a5e29bf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c78bd9e8304415fbce8aaf0ff11d9bc39e8ee0e78025aed9332c9f421574b9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c78bd9e8304415fbce8aaf0ff11d9bc39e8ee0e78025aed9332c9f421574b9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0c78bd9e8304415fbce8aaf0ff11d9bc39e8ee0e78025aed9332c9f421574b9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e05526307b272cbc582299b3cd5a818b94d9e88e69775a0bb4a18a77159c8fe"
    sha256 cellar: :any_skip_relocation, ventura:       "6e05526307b272cbc582299b3cd5a818b94d9e88e69775a0bb4a18a77159c8fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dee44cc8114fc5a5cddc3fd5aaadf7caf0f27bb6df5fb6f4a17dea3818111bff"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "kubectl-ai [flags]", shell_output("#{bin}/kubectl-ai --help")

    ENV["GEMINI_API_KEY"] = "test"

    PTY.spawn(bin/"kubectl-ai") do |r, w, pid|
      sleep 1
      w.puts "test"
      sleep 1
      output = r.read_nonblock(1024)
      assert_match "Error 400, Message: API key not valid", output
    rescue Errno::EIO
      # End of input, ignore
    ensure
      Process.kill("TERM", pid)
    end
  end
end
