class Sendme < Formula
  desc "Tool to send files and directories, based on iroh"
  homepage "https://iroh.computer/sendme"
  url "https://github.com/n0-computer/sendme/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "d50c39cbe828947a5acf67f4c0d1db46017ff9e2fe2c8e77970dd515b1b024d7"
  license "MIT"
  head "https://github.com/n0-computer/sendme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52350173ae98d8b6294d9bc093eb53c476364976a3ae24f62212ed85dec5f7fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce4fa5369ee7bc52464960e94aad679e57680421a84429dca4491097cf40d420"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5ed3896c3229be36bca39ab24a6f5702f509381f5035ddedfe152d13eede8170"
    sha256 cellar: :any_skip_relocation, sonoma:        "d547c26d3265b54c4b4e0aa2176ee93a36a19fb1bd9bd10d49016595eb58872f"
    sha256 cellar: :any_skip_relocation, ventura:       "c25fa5b5e18e41f67bbc93ec25f353148505c2750bfd2bce4648b1e12819ec22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0278655226c8298a67dd27b0c78d1fdba4ffc4470144598c26717d58bfbc8f48"
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
