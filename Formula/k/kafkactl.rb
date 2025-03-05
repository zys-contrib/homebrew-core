class Kafkactl < Formula
  desc "CLI for managing Apache Kafka"
  homepage "https://deviceinsight.github.io/kafkactl/"
  url "https://github.com/deviceinsight/kafkactl/archive/refs/tags/v5.5.1.tar.gz"
  sha256 "8bb984f5d0026dd7a474dfc259b3ac0a271983861aeb5ff770e74503ee019397"
  license "Apache-2.0"
  head "https://github.com/deviceinsight/kafkactl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9acad5b914763f89340a8a0cd62173fb2703e5acdcc1f8ca58765c6fa7a50c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9acad5b914763f89340a8a0cd62173fb2703e5acdcc1f8ca58765c6fa7a50c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e9acad5b914763f89340a8a0cd62173fb2703e5acdcc1f8ca58765c6fa7a50c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "959aa526759e6a7b40ed808b5eea08efb980f686d41af10b757b04764c516974"
    sha256 cellar: :any_skip_relocation, ventura:       "959aa526759e6a7b40ed808b5eea08efb980f686d41af10b757b04764c516974"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff2f34ce6e8c6b4a177bb44e62e45ac78cd8aafe316858e54ab39f404c95bba2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/deviceinsight/kafkactl/v5/cmd.Version=#{version}
      -X github.com/deviceinsight/kafkactl/v5/cmd.GitCommit=#{tap.user}
      -X github.com/deviceinsight/kafkactl/v5/cmd.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kafkactl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kafkactl version")

    output = shell_output("#{bin}/kafkactl produce greetings 2>&1", 1)
    assert_match "Failed to open Kafka producer", output
  end
end
