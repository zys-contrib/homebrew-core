class Chdig < Formula
  desc "Dig into ClickHouse with TUI interface"
  homepage "https://github.com/azat/chdig"
  url "https://github.com/azat/chdig/archive/refs/tags/v25.3.1.tar.gz"
  sha256 "69fd0063279d4299d760a43a039ceb70064c0e8f24c9bec57c3924aaadcd4216"
  license "MIT"
  head "https://github.com/azat/chdig.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"chdig", "--completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chdig --version")

    # failed with Linux CI, `No such device or address (os error 6)`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    output = shell_output("#{bin}/chdig --url 255.255.255.255 dictionaries 2>&1", 1)
    assert_match "Error: Cannot connect to ClickHouse", output
  end
end
