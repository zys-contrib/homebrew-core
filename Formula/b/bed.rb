class Bed < Formula
  desc "Binary editor written in Go"
  homepage "https://github.com/itchyny/bed"
  url "https://github.com/itchyny/bed/archive/refs/tags/v0.2.5.tar.gz"
  sha256 "a8fa1bddcf65fd3dd52ede2f3fc1cb2840420e9a24fb8fd8c950a9bab9d86f70"
  license "MIT"
  head "https://github.com/itchyny/bed.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.revision=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/bed"
  end

  test do
    # bed is a TUI application
    assert_match version.to_s, shell_output("#{bin}/bed -version")
  end
end
