class Tabiew < Formula
  desc "TUI to view and query delimited files (CSV/TSV/etc.)"
  homepage "https://github.com/shshemi/tabiew"
  url "https://github.com/shshemi/tabiew/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "2f7e13e27f0e8cf7c9b135d1c7480a65b6ad86c3f984205854051c6dbbeba97c"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "target/manual/tabiew.1" => "tw.1"
    bash_completion.install "target/completion/tw.bash"
    zsh_completion.install "target/completion/_tw"
    fish_completion.install "target/completion/tw.fish"
  end

  test do
    (testpath/"test.csv").write <<~EOS
      time,tide,wait
      1,42,"no man"
      7,11,"you think?"
    EOS
    input, = Open3.popen2 "script -q output.txt"
    input.puts "stty rows 80 cols 130"
    input.puts bin/"tw test.csv"
    input.puts ":F tide < 40"
    sleep 1
    input.puts ":q"

    sleep 2
    File.open(testpath/"output.txt") do |f|
      contents = f.read
      assert_match "you think?", contents
    end
  end
end
