class Mhonarc < Formula
  desc "Mail-to-HTML converter"
  homepage "https://www.mhonarc.org/"
  url "https://cpan.metacpan.org/authors/id/L/LD/LDIDRY/MHonArc-2.6.24.tar.gz"
  sha256 "457dc7374ee59cb75a0729e51cef2f2c52b48180f739d8fd956ea19882815f33"
  license "GPL-2.0-or-later"
  head "https://github.com/sympa-community/mhonarc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e4d56bb7e4a40a68b0a23faf8d4df159142e6e4f1f55ebd457fffd64e478a6d9"
  end

  depends_on "perl"

  def install
    # Using Perl's `installprefix` rather than `prefix` allows install.me to use
    # Homebrew Perl directory structure even if the prefixes are different paths.
    inreplace "install.me", "$Config{'prefix'}", "$Config{'installprefix'}"

    system "perl", "install.me",
           "-batch",
           "-perl", Formula["perl"].opt_bin/"perl",
           "-prefix", prefix

    bin.install "mhonarc"
  end

  test do
    system bin/"mhonarc", "-v"
  end
end
