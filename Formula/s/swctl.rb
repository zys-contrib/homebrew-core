class Swctl < Formula
  desc "Apache SkyWalking CLI (Command-line Interface)"
  homepage "https://skywalking.apache.org/"
  url "https://github.com/apache/skywalking-cli/archive/refs/tags/0.14.0.tar.gz"
  sha256 "9b1861a659e563d2ba7284ac19f3ae72649f08ac7ff7064aee928a7df2cd2bff"
  license "Apache-2.0"
  head "https://github.com/apache/skywalking-cli.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/swctl"

    # upstream pr to support zsh and fish completions, https://github.com/apache/skywalking-cli/pull/207
    generate_completions_from_executable(bin/"swctl", "completion", shells: [:bash])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/swctl --version 2>&1")

    output = shell_output("#{bin}/swctl --display yaml service ls 2>&1", 1)
    assert_match "level=fatal msg=\"Post \\\"http://127.0.0.1:12800/graphql\\\"", output
  end
end
