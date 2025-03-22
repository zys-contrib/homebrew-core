class Leetgo < Formula
  desc "CLI tool for LeetCode"
  homepage "https://github.com/j178/leetgo"
  url "https://github.com/j178/leetgo/archive/refs/tags/v1.4.13.tar.gz"
  sha256 "b92f1708b1420e85c6b97e41f8a09b127a42c387918cba950543e1713195384d"
  license "MIT"
  head "https://github.com/j178/leetgo.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/j178/leetgo/constants.Version=#{version}
      -X github.com/j178/leetgo/constants.Commit=#{tap.user}
      -X github.com/j178/leetgo/constants.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"leetgo", "completion")
  end

  test do
    assert_match "leetgo version #{version}", shell_output("#{bin}/leetgo --version")
    system bin/"leetgo", "init"
    assert_path_exists testpath/"leetgo.yaml"
  end
end
