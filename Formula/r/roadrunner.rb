class Roadrunner < Formula
  desc "High-performance PHP application server, load-balancer and process manager"
  homepage "https://docs.roadrunner.dev/docs"
  url "https://github.com/roadrunner-server/roadrunner/archive/refs/tags/v2025.1.1.tar.gz"
  sha256 "f0469f753b5f968254a696e52f7a0fc7e41d806d71fd53e2eda3d2c25697da20"
  license "MIT"
  head "https://github.com/roadrunner-server/roadrunner.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5326d280f593c8ae739316215a3dbad5470285a8ab19154b911c28a0297a01cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b6c3697272d40068dda788961c4dca1408c9ff53ec5edaafd9fcd3c8b29c43f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "76def568678640d4562ed767381c978566e5676b5c05180ce290aa44b00a4e2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad0502a742fcbddf75b778e67a675b2dc754c9e43f0a72e5d1b849af65c45204"
    sha256 cellar: :any_skip_relocation, ventura:       "a5911cada6312f4079ba959c568e3fa83353ef53b0a456407a64759057a6c524"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8f0412840fa072a2c9374b8905063eb71d98f7f317cbf6506b0648e7f94e27e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/roadrunner-server/roadrunner/v#{version.major}/internal/meta.version=#{version}
      -X github.com/roadrunner-server/roadrunner/v#{version.major}/internal/meta.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "aws", output: bin/"rr"), "./cmd/rr"

    generate_completions_from_executable(bin/"rr", "completion")
  end

  test do
    port = free_port
    (testpath/".rr.yaml").write <<~YAML
      # RR configuration version
      version: '3'
      rpc:
        listen: tcp://127.0.0.1:#{port}
    YAML

    output = shell_output("#{bin}/rr jobs list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/rr --version")
  end
end
