class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "e2f6b43715cefc00f1a07c84bb899fddc5defa3f69a1a68f5a4051680b0ca4b5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "967e0bdaf42f016182509ac0d7acc844ac9847544e6e32ec5803aa5d57db428b"
    sha256 cellar: :any,                 arm64_sonoma:  "7615829c89fc474ab98f0b9496e9d3bf98375767094553c570edb619949ebc7b"
    sha256 cellar: :any,                 arm64_ventura: "79604848a0156da95a3459006047f64126412103f49251270002961526f78915"
    sha256 cellar: :any,                 sonoma:        "455afed9691db04dbdfcb6f3bbb3bed478c80771ab9f307de3cdcb1b8302218b"
    sha256 cellar: :any,                 ventura:       "a795e7a4302279d5edbb4c0f87dd3778c6c1871ee3fe18dc6d3353c57d5288f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c44d32afb63a2d8d24c13edd167968834e581ea58872499fde071f259f93f8ab"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "yara"

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
