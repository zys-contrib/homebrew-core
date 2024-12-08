class Flashrom < Formula
  desc "Identify, read, write, verify, and erase flash chips"
  homepage "https://flashrom.org/"
  url "https://download.flashrom.org/releases/flashrom-v1.5.0.tar.xz"
  sha256 "3ef431cd0f039c1f7b929e81be145885e79192d16a843827e42977f488d9fec5"
  license "GPL-2.0-or-later"
  head "https://review.coreboot.org/flashrom.git", branch: "master"

  livecheck do
    url "https://download.flashrom.org/releases/"
    regex(/href=.*?flashrom[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "f7d23af87392e5d84eee90c05b77ceaa3c607df03fed061fa5a442486ed5e801"
    sha256 cellar: :any,                 arm64_sonoma:   "f6a24fb6e9db1e1283cdbc40e045b004ad53f12bc86a1f3f63407abfc361400a"
    sha256 cellar: :any,                 arm64_ventura:  "2e892b95bdc41d71063b3279f258e9b6ab010cc000d3fb2aec3c755fee1455f4"
    sha256 cellar: :any,                 arm64_monterey: "bbe8b4003bf7f78060ff7e174e66043277c28993206fd6d98b4101bf18799a4b"
    sha256 cellar: :any,                 sonoma:         "66f0c3e9c787271359921b10a5e624a96667f3b2052fbfb068f17b890484d99b"
    sha256 cellar: :any,                 ventura:        "f07e8bc13a2567551ff670e2b3565ba9e4613dffab040470c52b8e970f4ad6e5"
    sha256 cellar: :any,                 monterey:       "414ad270f9b00e71d020f99779b6b428646ebab33160d4967c506728505b8169"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a81a9eb50bf2cbfd072cbc065c1793e197690fbb08f8a3c6aad12e1692674190"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "libftdi"
  depends_on "libusb"
  depends_on "openssl@3"

  resource "DirectHW" do
    url "https://github.com/PureDarwin/DirectHW/archive/refs/tags/DirectHW-1.tar.gz"
    sha256 "14cc45a1a2c1a543717b1de0892c196534137db177413b9b85bedbe15cbe4563"
  end

  def install
    ENV["CONFIG_RAYER_SPI"] = "no"
    ENV["CONFIG_ENABLE_LIBPCI_PROGRAMMERS"] = "no"

    # install DirectHW for osx x86 builds
    if OS.mac? && Hardware::CPU.intel?
      (buildpath/"DirectHW").install resource("DirectHW")
      ENV.append "CFLAGS", "-I#{buildpath}"
    end

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system sbin/"flashrom", "--version"

    output = shell_output("#{sbin}/flashrom --erase --programmer dummy 2>&1", 1)
    assert_match "No EEPROM/flash device found", output
  end
end
