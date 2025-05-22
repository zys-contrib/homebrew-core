class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://github.com/weaviate/weaviate/archive/refs/tags/v1.30.4.tar.gz"
  sha256 "09eb6e9fc9945081d2cc596bf28e432d34c21361f1b35ef48994e155d4361b13"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85380da027e0a7a6e0e9b292a072750eb1919ebc29e138510320b92e836c3805"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85380da027e0a7a6e0e9b292a072750eb1919ebc29e138510320b92e836c3805"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "85380da027e0a7a6e0e9b292a072750eb1919ebc29e138510320b92e836c3805"
    sha256 cellar: :any_skip_relocation, sonoma:        "48284e26f28032b2f53ceb0abc7d1f106f164a49df60761da12bbfaef9cbbc94"
    sha256 cellar: :any_skip_relocation, ventura:       "48284e26f28032b2f53ceb0abc7d1f106f164a49df60761da12bbfaef9cbbc94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1c2f2a29c409e9eebb084c61205c52bdbc96b23f10e4f8e4ff835d3493c0c13"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/weaviate/weaviate/usecases/build.Version=#{version}
      -X github.com/weaviate/weaviate/usecases/build.BuildUser=#{tap.user}
      -X github.com/weaviate/weaviate/usecases/build.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/weaviate-server"
  end

  test do
    port = free_port
    pid = spawn bin/"weaviate", "--host", "0.0.0.0", "--port", port.to_s, "--scheme", "http"
    sleep 10
    assert_match version.to_s, shell_output("curl localhost:#{port}/v1/meta")
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end
