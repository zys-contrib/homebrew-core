class YaraX < Formula
  desc "Tool to do pattern matching for malware research"
  homepage "https://virustotal.github.io/yara-x/"
  url "https://github.com/VirusTotal/yara-x/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "e0457c0cd4f6a7a1c4c0e5df7453af49f3d8027453fd1fc053a1491ca1823122"
  license "BSD-3-Clause"
  head "https://github.com/VirusTotal/yara-x.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8091bed57071a0e879a57e604eff39832ffb904120d1bb34f96666c6c455975a"
    sha256 cellar: :any,                 arm64_sonoma:  "e26f750314254c0b9ec5a2ef5d564b31658577f5a422f940760a8c36111dd475"
    sha256 cellar: :any,                 arm64_ventura: "bc3f6a357cb9f432d7ef56962367f862925c28d286929cebadfff32ad95eb150"
    sha256 cellar: :any,                 sonoma:        "a7b5f6508bd875fe780bfa529c3de5336955cca4cbd168dab2f5857deefbb3ee"
    sha256 cellar: :any,                 ventura:       "c75158ee76e14430ea03f8175941a2a7a3a657780668e9647c24072335692c62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd53aea4851259f822ba58d5fa863fa406e71660dc376b9494e7b97b3c9de426"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fbdf9d8ad0a2561e60172de60f5a44ed2ebc3cfe4e5a518314763e1f0b3e686"
  end

  depends_on "cargo-c" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    system "cargo", "cinstall", "-p", "yara-x-capi", "--jobs", ENV.make_jobs.to_s, "--release",
                    "--prefix", prefix, "--libdir", lib

    generate_completions_from_executable(bin/"yr", "completion")
  end

  test do
    # test flow similar to yara
    rules = testpath/"commodore.yara"
    rules.write <<~EOS
      rule chrout {
        meta:
          description = "Calls CBM KERNEL routine CHROUT"
        strings:
          $jsr_chrout = {20 D2 FF}
          $jmp_chrout = {4C D2 FF}
        condition:
          $jsr_chrout or $jmp_chrout
      }
    EOS

    program = testpath/"zero.prg"
    program.binwrite [0x00, 0xc0, 0xa9, 0x30, 0x4c, 0xd2, 0xff].pack("C*")

    assert_equal <<~EOS.strip, shell_output("#{bin}/yr scan #{rules} #{program}").strip
      chrout #{program}
    EOS

    assert_match version.to_s, shell_output("#{bin}/yr --version")
  end
end
