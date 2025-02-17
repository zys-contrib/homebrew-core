class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://github.com/weaviate/weaviate/archive/refs/tags/v1.28.6.tar.gz"
  sha256 "9de35f308421e7c3fdc0f07961e6e3e24cc1f46465b999c2b08bb2273054f9e7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bb0c2618d9c45b4360d2cac205185ba494ab6689c472a0f95ba7d9f7ec2ab5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1bb0c2618d9c45b4360d2cac205185ba494ab6689c472a0f95ba7d9f7ec2ab5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1bb0c2618d9c45b4360d2cac205185ba494ab6689c472a0f95ba7d9f7ec2ab5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "13009e23b5dc280d809738d76517041e5713a1e6249c2c6ff49c1196de89b054"
    sha256 cellar: :any_skip_relocation, ventura:       "13009e23b5dc280d809738d76517041e5713a1e6249c2c6ff49c1196de89b054"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef15371967664eff5e2fe547e7ee891bc4bfc395ba6f8f147df4a05ece6e8892"
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
