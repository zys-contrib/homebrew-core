class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https://mindersec.github.io/"
  url "https://github.com/mindersec/minder/archive/refs/tags/v0.0.74.tar.gz"
  sha256 "a9686a563cab3d8402b9ebb29298f021e9d6ab2d60db16999844ae308c276b0e"
  license "Apache-2.0"
  head "https://github.com/mindersec/minder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e226e2b04d3862b4843c0390bde19f60df727a9af8c2e8221b732df8bc26f2c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e226e2b04d3862b4843c0390bde19f60df727a9af8c2e8221b732df8bc26f2c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e226e2b04d3862b4843c0390bde19f60df727a9af8c2e8221b732df8bc26f2c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "124734aaff5e04622128e9fb78c76ae60856ef2d6feac0ca0867dc25580404c3"
    sha256 cellar: :any_skip_relocation, ventura:       "c4a8d74691f2b08de85279986993ee06123b52e2205ee45a1278efda75c3279c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a320ab04c9b39e5eded16fa4489ea314644514530ebc43ac5aa1decd6517f7c5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/mindersec/minder/internal/constants.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"minder", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minder version")

    output = shell_output("#{bin}/minder artifact list -p github 2>&1", 16)
    assert_match "No config file present, using default values", output
  end
end
