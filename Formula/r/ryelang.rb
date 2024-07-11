class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://github.com/refaktor/rye/archive/refs/tags/v0.0.20.tar.gz"
  sha256 "872d67062dfde0c815d59236ac98c53579d5dc1f9ecf2c6720819b19cfb59e6d"
  license "Apache-2.0"
  head "https://github.com/refaktor/rye.git", branch: "main"

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"hello.rye").write <<~EOS
      "Hello World" .replace "World" "Mars" |print
      "12 8 12 16 8 6" .load .unique .sum |print
    EOS
    assert_predicate testpath/"hello.rye", :exist?
    output = shell_output("#{bin}/ryelang hello.rye 2>&1")
    assert_equal "Hello Mars\n42", output.strip
  end
end
