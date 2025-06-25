class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://github.com/weaviate/weaviate/archive/refs/tags/v1.31.3.tar.gz"
  sha256 "c11b9a7a1c03c0518d7f5ae381df3534fc6a3fb25e71345c7b2f8153205b1f1d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32d83de3e0b1f9cb26a392e8c1e6e81a3efaad993bb28624ab922c103a9e4c5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32d83de3e0b1f9cb26a392e8c1e6e81a3efaad993bb28624ab922c103a9e4c5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "32d83de3e0b1f9cb26a392e8c1e6e81a3efaad993bb28624ab922c103a9e4c5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1b226dae4aba57fea41e6fcc59c7653873a3b37a11008ce605c88bbb6259000"
    sha256 cellar: :any_skip_relocation, ventura:       "c1b226dae4aba57fea41e6fcc59c7653873a3b37a11008ce605c88bbb6259000"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7af4614c3be8a7aa6089f907f93dbbf39b1afd7a6e758d6b1826576f08d5373"
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
