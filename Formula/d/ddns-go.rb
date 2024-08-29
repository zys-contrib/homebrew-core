class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.7.0.tar.gz"
  sha256 "02e850e10fef76fef41102f11fa5c606d77cab876056618d36663e1869496353"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e494516eb5574cc27cac4e6a7dbabd66310ff127591047680d03a3fd401971c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e494516eb5574cc27cac4e6a7dbabd66310ff127591047680d03a3fd401971c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e494516eb5574cc27cac4e6a7dbabd66310ff127591047680d03a3fd401971c"
    sha256 cellar: :any_skip_relocation, sonoma:         "34a88893d08bb39b0ec1afb19c00d22f65467ebb884b9b3c7adf8c6ca55baa7d"
    sha256 cellar: :any_skip_relocation, ventura:        "34a88893d08bb39b0ec1afb19c00d22f65467ebb884b9b3c7adf8c6ca55baa7d"
    sha256 cellar: :any_skip_relocation, monterey:       "34a88893d08bb39b0ec1afb19c00d22f65467ebb884b9b3c7adf8c6ca55baa7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d224de91257d45a0ac7fe5032bf592dc24340baae8236a746f0f46e8c00911a"
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
