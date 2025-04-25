class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-05.03.06.tar.gz"
  sha256 "ca63c147ccd154805ecb80f85f435d48705cb06f5685c9ac1610c5661427e223"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "2a4f7f92cb06a3eb67bffd5c202532489543ce625b13fdf1f8ac63d5c827fd67"
    sha256 arm64_sonoma:  "b735dac1e89c0b476c331e23483e78b06def50c75a7c670eccea6f36829b8321"
    sha256 arm64_ventura: "3cca7b705afc133bec7fccfd98fac4cf72d623fabe50ca14900ede4fb3e78fbf"
    sha256 sonoma:        "1485093c92771312c5871e46e426f79e5c976843e02d3a959e42b0dfb1bd3984"
    sha256 ventura:       "8bd4246f518930674497a3cb428064964ea5b228aad68dcb330b43d2901f66cd"
    sha256 arm64_linux:   "9c21778b244d799f910e995ec9548b6a542ccf7f27ae8026ab8e974f13bd970b"
    sha256 x86_64_linux:  "784fcf32166ad34b0c9583336bcb06d936908e77233b80e5940abc031e7bc3a5"
  end

  conflicts_with "rem", because: "both install `rem` binaries"

  def install
    # Fix to error: unsupported option '-ffat-lto-objects' for target 'arm64-apple-darwin24.4.0'
    inreplace "configure", "-ffat-lto-objects", "" if DevelopmentTools.clang_build_version >= 1700

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"reminders.rem").write <<~REM
      SET $OnceFile "./once.timestamp"
      REM ONCE 2015-01-01 MSG Homebrew Test
    REM
    assert_equal "Reminders for Thursday, 1st January, 2015:\n\nHomebrew Test\n\n",
      shell_output("#{bin}/remind reminders.rem 2015-01-01")
  end
end
