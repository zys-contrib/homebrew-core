class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.8.6.tar.gz"
  sha256 "282f46640dccfe4b254ae4d0025e983ab8d0273c177966512523e988c0a4a13f"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "791b8b3abdb78182e80c065dc39e1e33511a9d42361c56d9f1b6aabc863d210e"
    sha256 cellar: :any,                 arm64_sonoma:  "204313a9f1b0feb2b5c4462da364a16899371b416e85570a438952b0d7313c29"
    sha256 cellar: :any,                 arm64_ventura: "b9f3ca66fb8c7ed1b91c7830f6be70e5b723e066776d26c3b9d1ad1017b6d45a"
    sha256 cellar: :any,                 sonoma:        "d4f27aad582a1893b5e3e11b6cb1b1e6bda6e3688c26bd23d3ab2b753789bfaa"
    sha256 cellar: :any,                 ventura:       "75fcd3417df05b7ded112f989ec8c9665a77e0fc0302a7ffdf85c4192057cd7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "007dbb723d6950dd7316ad76b1444e2adcbfd89668ebb7a56baa23994b59736b"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "yara-x"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.BuildVersion=#{version}", output: bin/"mal"), "./cmd/mal"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mal --version")

    (testpath/"test.py").write <<~PYTHON
      import subprocess
      subprocess.run(["echo", "execute external program"])
    PYTHON

    assert_match "program — execute external program", shell_output("#{bin}/mal analyze #{testpath}")
  end
end
