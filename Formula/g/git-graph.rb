class GitGraph < Formula
  desc "Command-line tool to show clear git graphs arranged for your branching model"
  homepage "https://github.com/mlange-42/git-graph"
  url "https://github.com/mlange-42/git-graph/archive/refs/tags/0.6.0.tar.gz"
  sha256 "7620d1e6704a418ccdaee4a9d863a4426e3e92aa7f302de8d849d10ee126b612"
  license "MIT"
  head "https://github.com/mlange-42/git-graph.git", branch: "master"

  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "zlib"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-graph --version")

    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "Initial commit"

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"git-graph", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "Initial commit", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
