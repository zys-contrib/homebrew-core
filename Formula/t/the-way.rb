class TheWay < Formula
  desc "Code snippets manager for your terminal"
  homepage "https://github.com/out-of-cheese-error/the-way"
  url "https://github.com/out-of-cheese-error/the-way/archive/refs/tags/v0.20.3.tar.gz"
  sha256 "84e0610f6b74c886c6cfa92cbce5f1d4f4d12b6e504d379c11659ab9ef980e97"
  license "MIT"
  head "https://github.com/out-of-cheese-error/the-way.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"the-way", "complete")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/the-way --version")

    output = shell_output("#{bin}/the-way config default")
    assert_match "db_dir = 'the_way_db'", output

    system bin/"the-way", "list"
  end
end
