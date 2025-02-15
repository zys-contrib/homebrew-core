class Arelo < Formula
  desc "Simple auto reload (live reload) utility"
  homepage "https://github.com/makiuchi-d/arelo"
  url "https://github.com/makiuchi-d/arelo/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "44f014aece1c9032dcf887b8186701d003d87fd89609f738d70784c5e984d1dd"
  license "MIT"
  head "https://github.com/makiuchi-d/arelo.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/arelo --version")

    (testpath/"test.sh").write <<~EOS
      #!/bin/sh
      echo "Hello, world!"
    EOS
    chmod 0755, testpath/"test.sh"

    logfile = testpath/"arelo.log"
    arelo_pid = spawn bin/"arelo", "--pattern", "test.sh", "--", "./test.sh", out: logfile.to_s

    sleep 1
    touch testpath/"test.sh"
    sleep 1

    assert_predicate testpath/"test.sh", :exist?
    assert_match "Hello, world!", logfile.read
  ensure
    Process.kill("TERM", arelo_pid)
    Process.wait(arelo_pid)
  end
end
