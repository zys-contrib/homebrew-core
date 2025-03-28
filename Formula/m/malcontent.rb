class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.8.8.tar.gz"
  sha256 "8237a49ff067469c1e29a5d020e8c2a2d08bb6b5122826d43fa4aa96b0407003"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a1a8615fa9a332af2a514af65d23e3bcc7158d7cc9bea15a9212fdede9178098"
    sha256 cellar: :any,                 arm64_sonoma:  "6610c243c016ad2a53173c4cd1420ed47b615547be74aa463fa167a566cba5dd"
    sha256 cellar: :any,                 arm64_ventura: "6d167940661e65fbafbcd3761a8a8e32831528fc569b72838db2b75fcd006b31"
    sha256 cellar: :any,                 sonoma:        "e907aaea36f4a12189ab7d3bc7f0874a4f7e72b6ee5de51ab81590f10041a3ed"
    sha256 cellar: :any,                 ventura:       "01b15f934a271b3cbe21389fe5ad9172ae9574478ea3520b40e2f076926eaf21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b2cd159afef5de21e3e829b04cb86903a0af6a8560161a815351da0bdd8c6ff"
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
