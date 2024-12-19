class Orbiton < Formula
  desc "Fast and config-free text editor and IDE limited by VT100"
  homepage "https://roboticoverlords.org/orbiton/"
  url "https://github.com/xyproto/orbiton/archive/refs/tags/v2.68.6.tar.gz"
  sha256 "36510204d12f607dff6952ab80ee4fcad1cd5be873a41d2c8006a47ea5d9ebe9"
  license "BSD-3-Clause"
  head "https://github.com/xyproto/orbiton.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95639a0c1fcb00ec903b2bdd7083d40427839ba76b0bf51d14631108b57512b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95639a0c1fcb00ec903b2bdd7083d40427839ba76b0bf51d14631108b57512b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "95639a0c1fcb00ec903b2bdd7083d40427839ba76b0bf51d14631108b57512b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "0feaf0e2963bf7a6090118ed69272c3df35f749ca7b0914f47f7a7595a0b9690"
    sha256 cellar: :any_skip_relocation, ventura:       "0feaf0e2963bf7a6090118ed69272c3df35f749ca7b0914f47f7a7595a0b9690"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "030cde00595df720272ea695b87792c0a55f4d23f5aef66dfafea5bc702ad5eb"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "xorg-server" => :test
    depends_on "xclip"
  end

  def install
    system "make", "install", "symlinks", "license", "DESTDIR=", "PREFIX=#{prefix}", "MANDIR=#{man}"
  end

  test do
    (testpath/"hello.txt").write "hello\n"
    copy_command = "#{bin}/o --copy #{testpath}/hello.txt"
    paste_command = "#{bin}/o --paste #{testpath}/hello2.txt"

    if OS.linux?
      system "xvfb-run", "sh", "-c", "#{copy_command} && #{paste_command}"
    else
      system copy_command
      system paste_command
    end

    assert_equal (testpath/"hello.txt").read, (testpath/"hello2.txt").read
  end
end
