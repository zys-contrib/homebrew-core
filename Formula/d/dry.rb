class Dry < Formula
  desc "Terminal application to manage Docker and Docker Swarm"
  homepage "https://moncho.github.io/dry/"
  url "https://github.com/moncho/dry/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "8fdb888f3f0c2298c531d5e23acfc0a55c7e4e881ad7365cc0dbecb8ec6c3b89"
  license "MIT"
  head "https://github.com/moncho/dry.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/moncho/dry/version.VERSION=#{version}
      -X github.com/moncho/dry/version.GITCOMMIT=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dry --version")
    assert_match "A tool to interact with a Docker Daemon from the terminal", shell_output("#{bin}/dry --description")
    assert_match "Dry could not start", shell_output("#{bin}/dry --profile 2>&1")
  end
end
