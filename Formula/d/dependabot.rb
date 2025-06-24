class Dependabot < Formula
  desc "Tool for testing and debugging Dependabot update jobs"
  homepage "https://github.com/dependabot/cli"
  url "https://github.com/dependabot/cli/archive/refs/tags/v1.67.0.tar.gz"
  sha256 "3f6f7fd63425872ccd606270c172e72af9f66aa8df29db90e6953447403c8196"
  license "MIT"
  head "https://github.com/dependabot/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75ae622b0ab8693876bcf380cd4da6dc37c6975962bbe16a17cffde5ccc4a5a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75ae622b0ab8693876bcf380cd4da6dc37c6975962bbe16a17cffde5ccc4a5a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "75ae622b0ab8693876bcf380cd4da6dc37c6975962bbe16a17cffde5ccc4a5a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "85c45e578a938fc75f51044d7ada9f75d37eb44747a24642b2fb9c474ad49df5"
    sha256 cellar: :any_skip_relocation, ventura:       "85c45e578a938fc75f51044d7ada9f75d37eb44747a24642b2fb9c474ad49df5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4fe9485b24309304662ea132c5e58621631c1d8766278a2ee055af27d38e9f3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/dependabot/cli/cmd/dependabot/internal/cmd.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/dependabot"

    generate_completions_from_executable(bin/"dependabot", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"
    assert_match("dependabot version #{version}", shell_output("#{bin}/dependabot --version"))
    output = shell_output("#{bin}/dependabot update bundler Homebrew/homebrew 2>&1", 1)
    assert_match("Cannot connect to the Docker daemon", output)
  end
end
