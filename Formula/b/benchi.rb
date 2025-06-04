class Benchi < Formula
  desc "Benchmarking tool for data pipelines"
  homepage "https://github.com/ConduitIO/benchi"
  url "https://github.com/ConduitIO/benchi/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "c97fc9f2e2fac7be61e9e9c2282e7ee1c9a5da78c3d6c10e40c472b1e79168ab"
  license "Apache-2.0"
  head "https://github.com/ConduitIO/benchi.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/benchi"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/benchi -v")

    # Fails in Linux CI with "open /dev/tty: no such device or address"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    test_config = testpath/"bench.yml"
    test_config.write <<~YAML
      name: test-benchmark
      iterations: 1
      pipeline:
        source:
          type: generator
          config:
            records: 1
        processors: []
        destination:
          type: noop
    YAML

    output = shell_output("#{bin}/benchi -config #{test_config} -out #{testpath} 2>&1", 1)
    assert_match "Cannot connect to the Docker daemon", output
  end
end
