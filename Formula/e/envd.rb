class Envd < Formula
  desc "Reproducible development environment for AI/ML"
  homepage "https://envd.tensorchord.ai"
  url "https://github.com/tensorchord/envd/archive/refs/tags/v0.3.47.tar.gz"
  sha256 "d4d55f516fa5ca1aac68dbbb096a7bafcc09abc46fa27e8fb5472213df7b9275"
  license "Apache-2.0"
  head "https://github.com/tensorchord/envd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3ada617934fca8e963a8a0bc245ee1743f87361a979da79679c22d499979fb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d30850322f092bfc326425ba887ff9d2fc9963320141821af79296711703513a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9613b02eaeed2e90e580a25e34471da001851cf2b4f81b8d0f5cd740fcc440fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "daec65a95c47f5261742e5c60022a31b8a70e1efa605ee287b465b120d16bf90"
    sha256 cellar: :any_skip_relocation, ventura:       "69c14a25db051a5e66230ef51c998b8bb929e7ca8d0c51b289ba5f327a45ddf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f48709a3f3edcde16290cbc5a30162f06cf8e3b869015b0cfccceef9d76ed6bd"
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
