class Envd < Formula
  desc "Reproducible development environment for AI/ML"
  homepage "https://envd.tensorchord.ai"
  url "https://github.com/tensorchord/envd/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "2e2c437e97086642eb66afd5be4434e1cffb54eed5361bc9e26147d62f60fe8e"
  license "Apache-2.0"
  head "https://github.com/tensorchord/envd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1f435d15e6c79f47a5c509ecd1e6d5f33b3f096a111540b397071dac2bdb019"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f531a57820ece786fc3ace7ca936efbb6ea04e7d0a353a9597ea820422a5376"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "55819a3c51216cce1fdbdfee26b11ae403613fd74999b75a81039e590b35078f"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa10a85335dc0112be06a2801d8750b21b2db45968b48197d7056b7b22515c50"
    sha256 cellar: :any_skip_relocation, ventura:       "369dd02b6d66a778220d34725bba9f1ddc6938bd6103000782f3bf4f8216c8bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4441201d8b904f032d67d0b6396340cd86f42a1f2b1f8d7814c16733f54260c3"
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
    generate_completions_from_executable(bin/"envd", "completion", "--no-install", "--shell")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/envd version --short")

    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"
    expected = /failed to list containers: (Cannot|permission denied while trying to) connect to the Docker daemon/
    assert_match expected, shell_output("#{bin}/envd env list 2>&1", 1)
  end
end
