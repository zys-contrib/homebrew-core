class Sendme < Formula
  desc "Tool to send files and directories, based on iroh"
  homepage "https://iroh.computer/sendme"
  url "https://github.com/n0-computer/sendme/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "52cd84b40df4c7af87cbe82de5bec22d536cd63e98cbb457a811495d38366905"
  license "MIT"
  head "https://github.com/n0-computer/sendme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "009742856c7989e0c079dc07f8dd8e29cde7d090758b79439b77df5e5348c12d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35e189943605eee575b0ddb7eea8a2b786ff73702b48f859751cc8bd28e5f6f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "20920b258f088a7e190b751d0de305c0b52a5a60abc348d088202fabaf11c55c"
    sha256 cellar: :any_skip_relocation, sonoma:        "500c4f0987b1dd5fa6269f2a6b525f10f1a0ef09ce47316d7b4940c7069a60f5"
    sha256 cellar: :any_skip_relocation, ventura:       "b6b8cb416cb23b3ab863d81ab788e582e76ddfbf0510f9db7d069d8d33c551ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a1f013adf0db044df5de27999423c80d5edbb6926c8d7401f33d5ff7f21e10b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sendme --version")

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"sendme", "send", bin/"sendme", [:out, :err] => output_log.to_s
      sleep 2
      assert_match "imported file #{bin}/sendme", output_log.read
      assert_match "to get this data, use\nsendme receive", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
