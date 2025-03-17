class Arelo < Formula
  desc "Simple auto reload (live reload) utility"
  homepage "https://github.com/makiuchi-d/arelo"
  url "https://github.com/makiuchi-d/arelo/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "afd1ce3703b4ecc561dcfe917c8968405af12fbf4e4481792cfa1883b0ae6cd3"
  license "MIT"
  head "https://github.com/makiuchi-d/arelo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a65cd591d58a5581dd46a35489a1564b65fb085da85d282ab055565879d4cfb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a65cd591d58a5581dd46a35489a1564b65fb085da85d282ab055565879d4cfb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8a65cd591d58a5581dd46a35489a1564b65fb085da85d282ab055565879d4cfb"
    sha256 cellar: :any_skip_relocation, sonoma:        "c70fc1419c521df1d984b9461606e07390a68940e037f4faba5f44ff6b892c08"
    sha256 cellar: :any_skip_relocation, ventura:       "c70fc1419c521df1d984b9461606e07390a68940e037f4faba5f44ff6b892c08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e4d715cba448b13d5d7fca0275a00e858d12d225440f33df060b07ff20d68a0"
  end

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

    assert_path_exists testpath/"test.sh"
    assert_match "Hello, world!", logfile.read
  ensure
    Process.kill("TERM", arelo_pid)
    Process.wait(arelo_pid)
  end
end
