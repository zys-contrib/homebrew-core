class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-05.02.00.tar.gz"
  sha256 "916145b573a83505decaf7571aee660102b0b9c52b89886bffea9d81e82ebdd6"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "5879a0b59b4b3bae12cabb8c8f0b89cafd71e735e4c8ec4db1d9a15dd93f651d"
    sha256 arm64_sonoma:  "57818f7270c2a2810c31a9946525acc44ebf5f23af49de23b36113a34df36d52"
    sha256 arm64_ventura: "64d3afdacb0696bd3974d3f35f0a677a50e713cf7187537c148dead1e645c0bf"
    sha256 sonoma:        "8d4132f32cd79411d7c2f8f42a23da29f580f7c3cc9b9670f1a1bef096352369"
    sha256 ventura:       "a7cca45c517e9bc7dc256882fd59b966b659a7b52e90893a4c2e34f28133560e"
    sha256 x86_64_linux:  "876dd4fb7a687001f22a22685bbbb61b0300ec2ea3c9a64fedf3af61f92a4084"
  end

  conflicts_with "rem", because: "both install `rem` binaries"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"reminders").write "ONCE 2015-01-01 Homebrew Test"
    assert_equal "Reminders for Thursday, 1st January, 2015:\n\nHomebrew Test\n\n",
      shell_output("#{bin}/remind reminders 2015-01-01")
  end
end
