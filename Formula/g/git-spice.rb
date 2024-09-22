class GitSpice < Formula
  desc "Manage stacked Git branches"
  homepage "https://github.com/abhinav/git-spice"
  url "https://github.com/abhinav/git-spice/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "34b5161ca642bb70269c45b9726137832eb95737465c6134995de5be2e1ef1d6"
  license all_of: [
    "GPL-3.0-or-later",
    "BSD-3-Clause", # internal/komplete/{komplete.go, komplete_test.go}
  ]
  head "https://github.com/abhinav/git-spice.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main._version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"gs")

    generate_completions_from_executable(bin/"gs", "shell", "completion", base_name: "gs")
  end

  test do
    system "git", "init", "--initial-branch=main"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    touch "foo"
    system "git", "add", "foo"
    system "git", "commit", "-m", "bar"

    assert_match "main", shell_output("#{bin}/gs log long 2>&1")

    output = shell_output("#{bin}/gs branch create feat1 2>&1", 1)
    assert_match "error: Terminal is dumb, but EDITOR unset", output

    assert_match version.to_s, shell_output("#{bin}/gs --version")
  end
end
