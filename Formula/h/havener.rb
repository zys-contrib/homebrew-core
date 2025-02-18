class Havener < Formula
  desc "Swiss army knife for Kubernetes tasks"
  homepage "https://github.com/homeport/havener"
  url "https://github.com/homeport/havener/archive/refs/tags/v2.2.6.tar.gz"
  sha256 "f5fe8bc809694bd8c757c3ddaac91cdcc20eb9efc988dd736838b0a8bbfdf7e8"
  license "MIT"
  head "https://github.com/homeport/havener.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/homeport/havener/internal/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/havener"

    generate_completions_from_executable(bin/"havener", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/havener version")

    assert_match "unable to get access to cluster", shell_output("#{bin}/havener events 2>&1", 1)
  end
end
