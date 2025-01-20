class Envd < Formula
  desc "Reproducible development environment for AI/ML"
  homepage "https://envd.tensorchord.ai"
  url "https://github.com/tensorchord/envd/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "2ffc1e87caf8dcc82a4b04efcb1a6140b23f5a5c86afb5d619aad20a1a5fa25d"
  license "Apache-2.0"
  head "https://github.com/tensorchord/envd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71cde7071d5d929f72e14e1e3ca752af29052ae1e8d06216c4b232dceffcfe53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72c0d08b51c9966d42022d94bfbf0df354db932a0bb4e3495e1912d237acfedf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "037d12333f919d279f29e92017d89e7a4ab9f93fb20a7d0c3b0d170887dc9ef4"
    sha256 cellar: :any_skip_relocation, sonoma:        "da001511d3d18da95d2a7d25516098eababa311eb154e773cfe8a284bac817de"
    sha256 cellar: :any_skip_relocation, ventura:       "de83e5551738fdcdf83916715034e76e80d639a55044f9359b4b5bbcf31dfba1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f02da1ea0d4e78de89a3209a5c16a5ce3ca9551d165131f5eb41e1e902701219"
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
