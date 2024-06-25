class Testscript < Formula
  desc "Integration tests for command-line applications in .txtar format"
  homepage "https://github.com/rogpeppe/go-internal/tree/master/cmd/testscript"
  url "https://github.com/rogpeppe/go-internal/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "b51d588d05f3e82d3045545ef46bd758a0610b9cfde1ae243489a593908b6060"
  license "BSD-3-Clause"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/testscript"
  end

  test do
    (testpath/"hello.txtar").write("exec echo hello!\nstdout hello!")

    assert_equal "PASS\n", shell_output("#{bin}/testscript hello.txtar")
  end
end
