class Kool < Formula
  desc "Web apps development with containers made easy"
  homepage "https://kool.dev"
  url "https://github.com/kool-dev/kool/archive/refs/tags/3.3.0.tar.gz"
  sha256 "0b614cf4317a16c71edd7ad5973a10930b5f5ef342eb6dd840ada9debab61d70"
  license "MIT"
  head "https://github.com/kool-dev/kool.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X kool-dev/kool/commands.version=#{version}")

    generate_completions_from_executable(bin/"kool", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kool --version")
    assert_match "docker doesn't seem to be installed", shell_output("#{bin}/kool status 2>&1", 1)
  end
end
