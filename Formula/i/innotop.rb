class Innotop < Formula
  desc "Top clone for MySQL"
  homepage "https://github.com/innotop/innotop/"
  url "https://github.com/innotop/innotop/archive/refs/tags/v1.15.2.tar.gz"
  sha256 "cfedf31ba5617a5d53ff0fedc86a8578f805093705a5e96a5571d86f2d8457c0"
  license any_of: ["GPL-2.0-only", "Artistic-1.0-Perl"]
  head "https://github.com/innotop/innotop.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b712a7c6581579deb190f4ee7e259fd1d8d86a3eafcc0c6a995e1fa71782c5be"
    sha256 cellar: :any,                 arm64_sonoma:  "b6fee84229d2f0a4484314b92acdd6b4750d7568e8d0828f1b45a71084514a9a"
    sha256 cellar: :any,                 arm64_ventura: "ee625d9158716ac21cf295436c730adb65e90dae4ac01eac072318b114734739"
    sha256 cellar: :any,                 sonoma:        "d66f285ed55e8b517d496ff3f823872e9ceea88145d255e44048a10a631f27c3"
    sha256 cellar: :any,                 ventura:       "ba40a81476e96be812e92c8637717511e2051b5c97c0e1149bc29951a32b033e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "caa30fc17b6d41c74eeb3391afb5110b5675d61bcdf27ab8e66edb318c858c57"
  end

  depends_on "perl-dbd-mysql"

  uses_from_macos "perl"

  resource "Term::ReadKey" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/J/JS/JSTOWE/TermReadKey-2.38.tar.gz"
      sha256 "5a645878dc570ac33661581fbb090ff24ebce17d43ea53fd22e105a856a47290"
    end
  end

  def install
    ENV.prepend_path "PERL5LIB", Formula["perl-dbd-mysql"].opt_libexec/"lib/perl5"
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}", "INSTALLMAN1DIR=none", "INSTALLMAN3DIR=none"
        system "make", "install"
      end
    end

    system "perl", "Makefile.PL", "INSTALL_BASE=#{prefix}", "INSTALLSITEMAN1DIR=#{man1}"
    system "make", "install"
    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    # Calling commands throws up interactive GUI, which is a pain.
    assert_match version.to_s, shell_output("#{bin}/innotop --version")
  end
end
