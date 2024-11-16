class Tsduck < Formula
  desc "MPEG Transport Stream Toolkit"
  homepage "https://tsduck.io/"
  url "https://github.com/tsduck/tsduck/archive/refs/tags/v3.39-3956.tar.gz"
  sha256 "1a391504967bd7a6ffb1cabd98bc6ee904a742081c0a17ead4d6639d58c82979"
  license "BSD-2-Clause"
  head "https://github.com/tsduck/tsduck.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "96475b87976813903241cf98592d01cacf720e882a6e9ac98bbe934f82eef105"
    sha256 cellar: :any,                 arm64_sonoma:  "da97a4845370eb1f506f0802fd8695e3f4ba496b6203a5e75cb37aed6bafad37"
    sha256 cellar: :any,                 arm64_ventura: "c14a4574386893d0246638ef5596a9166aacfbe5bfdeba200bb9d15a1e21eed1"
    sha256 cellar: :any,                 sonoma:        "20f54631fba2329f9658ecb5237e738359806be48f23ecd8b997fce35f9c6f32"
    sha256 cellar: :any,                 ventura:       "a8ea6ad5d363de528af0c363c1c5c42114e1eaf1387e0a9ba0f38b32f1db0d6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec2639e010a13f3bbfac270123337df1be212d4215e9846851c969138b896196"
  end

  depends_on "asciidoctor" => :build
  depends_on "dos2unix" => :build
  depends_on "gnu-sed" => :build
  depends_on "grep" => :build
  depends_on "openjdk" => :build
  depends_on "qpdf" => :build
  depends_on "librist"
  depends_on "libvatek"
  depends_on "openssl@3"
  depends_on "srt"

  uses_from_macos "python" => :build
  uses_from_macos "curl"
  uses_from_macos "libedit"
  uses_from_macos "pcsc-lite"

  on_macos do
    depends_on "make" => :build
  end

  # fix syntax issue in make-config.sh, upstream pr ref, https://github.com/tsduck/tsduck/pull/1550
  patch do
    url "https://github.com/tsduck/tsduck/commit/393b8fe60329ad55efaa122840f19c8cd0cda75f.patch?full_index=1"
    sha256 "90e95a49b39f01c61b3420a5edf6c76df1b24e4a8f8cdf3cafd1aed0e95a3f2e"
  end

  def install
    ENV["LINUXBREW"] = "true" if OS.linux?
    system "gmake", "NOGITHUB=1", "NOTEST=1"
    ENV.deparallelize
    system "gmake", "NOGITHUB=1", "NOTEST=1", "install", "SYSPREFIX=#{prefix}"
  end

  test do
    assert_match "TSDuck - The MPEG Transport Stream Toolkit", shell_output("#{bin}/tsp --version 2>&1")
    input = shell_output("#{bin}/tsp --list=input 2>&1")
    %w[craft file hls http srt rist].each do |str|
      assert_match "#{str}:", input
    end
    output = shell_output("#{bin}/tsp --list=output 2>&1")
    %w[ip file hls srt rist].each do |str|
      assert_match "#{str}:", output
    end
    packet = shell_output("#{bin}/tsp --list=packet 2>&1")
    %w[fork tables analyze sdt timeshift nitscan].each do |str|
      assert_match "#{str}:", packet
    end
  end
end
