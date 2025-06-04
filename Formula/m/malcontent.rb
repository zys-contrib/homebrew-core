class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "3534a7a4baca5269af7c3db582fbffa5f91674f4f0b0f7b4e9f96595aa5c8505"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7d66397fef1567264822b45b0103a879f768699316f81412467ba1cd24482a54"
    sha256 cellar: :any,                 arm64_sonoma:  "46dcef392b48cbb9323e28fd5f17cadd423795843d063e6fb0e9a64cb382a55b"
    sha256 cellar: :any,                 arm64_ventura: "6b7e0d5d07c18a9c357ee57a6e3bc61b309a0faca039f650c9e776a5474a929d"
    sha256 cellar: :any,                 sonoma:        "62fd216fd39a008d28d17f39fc3f555653c3b00c72c1c8f1e3c803de82b2c47e"
    sha256 cellar: :any,                 ventura:       "0fc0338934dab10df2e6dec657acbbc2c326a5ce22b2936d1b386afe0f2a6dcd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c18f0935906885e8c882a15ddfe65b8890e42d8caa97d1e7add37bb24e930216"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd95e2fbec34d546908a9960779c50c3d4ba493b2be0be70512c76dbf0d2e953"
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
