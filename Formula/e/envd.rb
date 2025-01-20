class Envd < Formula
  desc "Reproducible development environment for AI/ML"
  homepage "https://envd.tensorchord.ai"
  url "https://github.com/tensorchord/envd/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "2ffc1e87caf8dcc82a4b04efcb1a6140b23f5a5c86afb5d619aad20a1a5fa25d"
  license "Apache-2.0"
  head "https://github.com/tensorchord/envd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e4e260192a471baa461c83a6e5b58e3bd2eae68a27cb9e09d583238cc87972c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28bb63e6d9169965165154f433f15ade1f3786ed506c1f4dfd580ad3c6f49229"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c0d2a7aebed63e9a6a7ee802de15d2d1436fa8aae284de60bafba610a2c06be5"
    sha256 cellar: :any_skip_relocation, sonoma:        "97626e8a3c162df8eb8b3016840d5b061d1be477f9f80cac45b0a5cc5c61eecd"
    sha256 cellar: :any_skip_relocation, ventura:       "3f494185dec2e5678bf1b2cb3cb3df1a76b213444b17cf2b2f6754f77e95d2f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b872a457d586ff03b188b577579e3e04b9ac92b2efbdf9d1dbfe0f57ce0e61c3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/tensorchord/envd/pkg/version.buildDate=#{time.iso8601}
      -X github.com/tensorchord/envd/pkg/version.version=#{version}
      -X github.com/tensorchord/envd/pkg/version.gitTag=v#{version}
      -X github.com/tensorchord/envd/pkg/version.gitCommit=#{tap.user}
      -X github.com/tensorchord/envd/pkg/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/envd"
    generate_completions_from_executable(bin/"envd", "completion", "--no-install",
                                         shell_parameter_format: "--shell=",
                                         shells:                 [:bash, :zsh, :fish])
  end

  test do
    output = shell_output("#{bin}/envd version --short")
    assert_equal "envd: v#{version}", output.strip

    expected = if OS.mac?
      "failed to list containers: Cannot connect to the Docker daemon"
    else
      "failed to list containers: permission denied while trying to connect to the Docker daemon"
    end

    stderr = shell_output("#{bin}/envd env list 2>&1", 1)
    assert_match expected, stderr
  end
end
