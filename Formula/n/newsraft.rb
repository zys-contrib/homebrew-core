class Newsraft < Formula
  desc "Terminal feed reader"
  homepage "https://codeberg.org/newsraft/newsraft"
  url "https://codeberg.org/newsraft/newsraft/archive/newsraft-0.29.tar.gz"
  sha256 "1dbec925d5556cae70e92dcc7b69cc4899473deb1d26a600b8903dbc0b3fde65"
  license "ISC"

  depends_on "scdoc" => :build
  depends_on "gumbo-parser"
  depends_on "ncurses"
  depends_on "yajl"

  uses_from_macos "curl"
  uses_from_macos "expat"
  uses_from_macos "sqlite"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/newsraft -v 2>&1")

    system "#{bin}/newsraft -l test 2>&1 || :"
    assert_match "Trying to initialize curses library...", File.read("test")
  end
end
