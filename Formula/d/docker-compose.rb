class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/refs/tags/v2.35.0.tar.gz"
  sha256 "37911c6303252c42d316dd5898b15b7e7054a9170d3ca2aafa2c5fce5fb6ec26"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53e559cb33d8d5dee16fb8ce47625f666bc7df39a63a1f9d8d0cb93f06e0f5fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b78958eebd65121ff158e6bb09f84ce0887127713ed676dfd249ad8ef057893"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d7ade1b8b69885a0de5b1436321fd73171203677aa3f0da85e08a76d19f039ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e658b3210d9aa7684344325ebf915fe82bc3b8f6c0132c6ad961ee064384ab2"
    sha256 cellar: :any_skip_relocation, ventura:       "b06c830a83ee63001b07a1645e90d00b51c5076a8da3046132348990d8a203b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45bf5f00be06e8e3cac7148292890b2a42b459be1fe8130aecaeaea4712feaed"
  end

  depends_on "go" => :build

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
