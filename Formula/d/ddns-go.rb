class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.7.2.tar.gz"
  sha256 "c583aa1dd160e1a87f4ed3a1ec4b7342c14a5c732f3929f435418a109d3a2a55"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d25b8ea9fcd76a691a85cf38d03144f19d7e0af289db04254eb834b4c9011ea4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d25b8ea9fcd76a691a85cf38d03144f19d7e0af289db04254eb834b4c9011ea4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d25b8ea9fcd76a691a85cf38d03144f19d7e0af289db04254eb834b4c9011ea4"
    sha256 cellar: :any_skip_relocation, sonoma:        "880dad4561262cd6c7703eba9189d5ca34b49823524108280af8482820ecceaa"
    sha256 cellar: :any_skip_relocation, ventura:       "880dad4561262cd6c7703eba9189d5ca34b49823524108280af8482820ecceaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08bca27f2a759a05f34e01202bf88b29001c4bedf732e6bf12ba7bfb3be493b8"
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
