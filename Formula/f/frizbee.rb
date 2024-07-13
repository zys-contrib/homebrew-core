class Frizbee < Formula
  desc "Throw a tag at and it comes back with a checksum"
  homepage "https://github.com/stacklok/frizbee"
  url "https://github.com/stacklok/frizbee/archive/refs/tags/v0.0.20.tar.gz"
  sha256 "305cb3e65cbd1d3557c312720e97657b1b6996621e94d1d15856ab6271ec3d1f"
  license "Apache-2.0"
  head "https://github.com/stacklok/frizbee.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/stacklok/frizbee/internal/cli.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"frizbee", "completion")
  end

  test do
    assert_match version.to_s, shell_output(bin/"frizbee version 2>&1")

    output = shell_output(bin/"frizbee actions $(brew --repository)/.github/workflows/tests.yml 2>&1")
    assert_match "Processed: tests.yml", output
  end
end
