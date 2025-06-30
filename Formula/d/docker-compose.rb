class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/refs/tags/v2.38.0.tar.gz"
  sha256 "4652699ab383b11ea570d9b3387820333263796fc77c66240194dc52d67b7e50"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8e9db630dd557042ff86b10c4ce90e8b127efdbc578e413b331715c9ca70a6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cf316e3b53b9d6853c3a0b57f2f01ef2bea566cd98b3f3f56d311c786c1c175"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5dd09ebb60d02f7026abfb9daa942a4220712a525463d141b1634fb658c377ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c055d01100d854cf493ec96404da655de98f70306c0fc5306cf261482ab1013"
    sha256 cellar: :any_skip_relocation, ventura:       "f8abd8bf5049fad243c4d9e6143e8b71625da18924ea2a4f08b2beb8b6e5db19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19991c655b795b17ffb91f527519962ff8705831f23846eda32bf04027f229cd"
  end

  depends_on "go" => :build

  conflicts_with cask: "docker"

  def install
    ldflags = %W[
      -s -w
      -X github.com/docker/compose/v2/internal.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd"

    (lib/"docker/cli-plugins").install_symlink bin/"docker-compose"
  end

  def caveats
    <<~EOS
      Compose is a Docker plugin. For Docker to find the plugin, add "cliPluginsExtraDirs" to ~/.docker/config.json:
        "cliPluginsExtraDirs": [
            "#{HOMEBREW_PREFIX}/lib/docker/cli-plugins"
        ]
    EOS
  end

  test do
    output = shell_output(bin/"docker-compose up 2>&1", 1)
    assert_match "no configuration file provided", output
  end
end
