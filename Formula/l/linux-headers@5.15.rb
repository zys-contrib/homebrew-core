class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.182.tar.gz"
  sha256 "eb4fe85945691cb705bac0e58564b8991e3ef7707eb0c1bf60def62f879d5556"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?linux[._-]v?(5\.15(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "c3403915352cc6bcc938755cd76b10dcbfbb2ccbdc65a890c55b0857d8263ea7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8367cf8edab4b971c1f14a337b48a8c06e9b11e35f834f678eea6f08e6d30fc8"
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
