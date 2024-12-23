class Humanlog < Formula
  desc "Logs for humans to read"
  homepage "https://github.com/humanlogio/humanlog"
  url "https://github.com/humanlogio/humanlog/archive/refs/tags/v0.7.8.tar.gz"
  sha256 "9984db35260541fbd1a8abe6b09fd2e30c9d77df3210087ffe04d72308bf9860"
  license "Apache-2.0"
  head "https://github.com/humanlogio/humanlog.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.versionMajor=#{version.major}
      -X main.versionMinor=#{version.minor}
      -X main.versionPatch=#{version.patch}
      -X main.versionPrerelease=
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/humanlog"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/humanlog --version")

    test_input = '{"time":"2024-12-23T12:34:56Z","level":"info","message":"brewtest log"}'
    expected_output = "brewtest log"

    output = pipe_output(bin/"humanlog", test_input)
    assert_match expected_output, output
  end
end
