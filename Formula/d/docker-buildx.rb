class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://github.com/docker/buildx/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "eab1eb18e06873c64ff1a0df00b298bcdbfd9c9515debbbac85b4c2cd0b228ff"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f62706d196c483f18d84e78e3bcfe48c890ad6d82c1d0194101532e9c9d7672"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f62706d196c483f18d84e78e3bcfe48c890ad6d82c1d0194101532e9c9d7672"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1f62706d196c483f18d84e78e3bcfe48c890ad6d82c1d0194101532e9c9d7672"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8756e1e9451029813ce09ad5d036af26cc124a33c3024bf7c7b5b65ed35b339"
    sha256 cellar: :any_skip_relocation, ventura:       "a8756e1e9451029813ce09ad5d036af26cc124a33c3024bf7c7b5b65ed35b339"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c69b2d3ef1765c6cebe9991a27842fe0c28a8c8459621b13cc80acb5685cbc93"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/docker/buildx/version.Version=v#{version}
      -X github.com/docker/buildx/version.Revision=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/buildx"

    (lib/"docker/cli-plugins").install_symlink bin/"docker-buildx"

    doc.install Dir["docs/reference/*.md"]

    generate_completions_from_executable(bin/"docker-buildx", "completion")
  end

  def caveats
    <<~EOS
      docker-buildx is a Docker plugin. For Docker to find the plugin, add "cliPluginsExtraDirs" to ~/.docker/config.json:
        "cliPluginsExtraDirs": [
            "#{HOMEBREW_PREFIX}/lib/docker/cli-plugins"
        ]
    EOS
  end

  test do
    assert_match "github.com/docker/buildx v#{version}", shell_output("#{bin}/docker-buildx version")
    output = shell_output(bin/"docker-buildx build . 2>&1", 1)
    assert_match(/(denied while trying to|Cannot) connect to the Docker daemon/, output)
  end
end
