class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.8.0.tar.gz"
  sha256 "7ec7134f18a9272fde4eaf0403013b5e3239a9bf1fc2be6ed68acb01ed94ca44"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50595e51acb40130a9f4e12eb9a61c2acea2861aaf804a615dd44a2197fdd5d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50595e51acb40130a9f4e12eb9a61c2acea2861aaf804a615dd44a2197fdd5d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "50595e51acb40130a9f4e12eb9a61c2acea2861aaf804a615dd44a2197fdd5d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "adf1b19cdd4398b6416716257a73da31273959f52a3d5bc1d12f3955281afabe"
    sha256 cellar: :any_skip_relocation, ventura:       "adf1b19cdd4398b6416716257a73da31273959f52a3d5bc1d12f3955281afabe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae5c21b7d2a27b6729c053b6be6232183b281c36b81f50e4970b473f2283ad0d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=v#{version}
      -X main.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ddns-go -v")

    port = free_port
    spawn "#{bin}/ddns-go -l :#{port} -c #{testpath}/ddns-go.yaml"
    sleep 1

    system "curl", "--silent", "localhost:#{port}/clearLog"
    output = shell_output("curl --silent localhost:#{port}/logs")
    assert_match "Temporary Redirect", output
  end
end
