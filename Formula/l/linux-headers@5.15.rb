class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.183.tar.gz"
  sha256 "34852edeea2d9e40fbd6596c9dffbcf0fbe43d95e45360fb7ce46c3a0942863e"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?linux[._-]v?(5\.15(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "c148928c9cb84159a5f35fbb8b980a79684e1926e12eabb04d914b8ab4dd1b98"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "33f742cffed587c14dcca8cc34f4993c5bb707c39356ff53612a0f0891264159"
  end

  depends_on :linux

  def install
    system "make", "headers"

    cd "usr/include" do
      Pathname.glob("**/*.h").each do |header|
        (include/header.dirname).install header
      end
    end
  end

  test do
    assert_match "KERNEL_VERSION", (include/"linux/version.h").read
  end
end
