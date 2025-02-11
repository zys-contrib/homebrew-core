class Ggh < Formula
  desc "Recall your SSH sessions"
  homepage "https://github.com/byawitz/ggh"
  url "https://github.com/byawitz/ggh/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "4692a306792444950f45472a01dcef478a5780203d7aaf1b7b959065a190fe64"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_equal "No history found.", shell_output(bin/"ggh").chomp
    assert_equal "No config found.", shell_output(bin/"ggh -").chomp
  end
end
