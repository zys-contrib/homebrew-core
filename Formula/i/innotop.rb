class Innotop < Formula
  desc "Top clone for MySQL"
  homepage "https://github.com/innotop/innotop/"
  url "https://github.com/innotop/innotop/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "6ec91568e32bda3126661523d9917c7fbbd4b9f85db79224c01b2a740727a65c"
  license any_of: ["GPL-2.0-only", "Artistic-1.0-Perl"]
  revision 10
  head "https://github.com/innotop/innotop.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a17005507753da73e8a13a96b378233d51dd27cc395eecbbf71fd7206bc40acf"
    sha256 cellar: :any,                 arm64_sonoma:  "49218a88a5c4b0bc005ca1dd974b408551dacad3514bf86c99635f96da787393"
    sha256 cellar: :any,                 arm64_ventura: "cf8f414fe93aa6ab94e1b8f56abec847fce802bd9774d64eae50a1fc4dc6e1e3"
    sha256 cellar: :any,                 sonoma:        "df181fa1cebc759da9f19b1c67977842b505195301a3a37b82f745f8b7217753"
    sha256 cellar: :any,                 ventura:       "4ab714cc8fea0aa2936abe48a665f2e66ce0516e8dfff847be69b105402db2aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5983d9ca80837dcc86692cb8a9a17963543cd71ad3cb599887cbc47a600840e"
  end

  depends_on "mysql-client"

  uses_from_macos "perl"

  resource "Devel::CheckLib" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MATTN/Devel-CheckLib-1.16.tar.gz"
    sha256 "869d38c258e646dcef676609f0dd7ca90f085f56cf6fd7001b019a5d5b831fca"
  end

  resource "DBI" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/H/HM/HMBRAND/DBI-1.645.tgz"
      sha256 "e38b7a5efee129decda12383cf894963da971ffac303f54cc1b93e40e3cf9921"
    end
  end

  resource "DBD::mysql" do
    url "https://cpan.metacpan.org/authors/id/D/DV/DVEEDEN/DBD-mysql-5.009.tar.gz"
    sha256 "8552d90dfddee9ef36e7a696da126ee1b42a1a00fbf2c6f3ce43ca2c63a5b952"
  end

  resource "Term::ReadKey" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/J/JS/JSTOWE/TermReadKey-2.38.tar.gz"
      sha256 "5a645878dc570ac33661581fbb090ff24ebce17d43ea53fd22e105a856a47290"
    end
  end

  def install
    ENV.prepend_create_path "PERL5LIB", buildpath/"build_deps/lib/perl5"
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resources.each do |r|
      r.stage do
        install_base = (r.name == "Devel::CheckLib") ? buildpath/"build_deps" : libexec

        # Skip installing man pages for libexec perl modules to reduce disk usage
        system "perl", "Makefile.PL", "INSTALL_BASE=#{install_base}", "INSTALLMAN1DIR=none", "INSTALLMAN3DIR=none"

        make_args = []
        if OS.mac? && r.name == "DBD::mysql"
          # Reduce overlinking on macOS
          make_args << "OTHERLDFLAGS=-Wl,-dead_strip_dylibs"
          # Work around macOS DBI generating broken Makefile
          inreplace "Makefile" do |s|
            old_dbi_instarch_dir = s.get_make_var("DBI_INSTARCH_DIR")
            new_dbi_instarch_dir = "#{MacOS.sdk_path_if_needed}#{old_dbi_instarch_dir}"
            s.change_make_var! "DBI_INSTARCH_DIR", new_dbi_instarch_dir
            s.gsub! " #{old_dbi_instarch_dir}/Driver_xst.h", " #{new_dbi_instarch_dir}/Driver_xst.h"
          end
        end

        system "make", "install", *make_args
      end
    end

    system "perl", "Makefile.PL", "INSTALL_BASE=#{prefix}", "INSTALLSITEMAN1DIR=#{man1}"
    system "make", "install"
    bin.env_script_all_files(libexec/"bin", PERL5LIB: libexec/"lib/perl5")
  end

  test do
    # Calling commands throws up interactive GUI, which is a pain.
    assert_match version.to_s, shell_output("#{bin}/innotop --version")
  end
end
