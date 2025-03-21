class StripNondeterminism < Formula
  desc "Tool for stripping bits of non-deterministic information from files"
  homepage "https://salsa.debian.org/reproducible-builds/strip-nondeterminism"
  url "https://salsa.debian.org/reproducible-builds/strip-nondeterminism/-/archive/1.14.1/strip-nondeterminism-1.14.1.tar.bz2"
  sha256 "149e5e7585cd1d8e777564d5772fb1afa5ed7be4a049c52ffc3a31de2bc04b93"
  license "GPL-3.0-or-later"
  head "https://salsa.debian.org/reproducible-builds/strip-nondeterminism.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4c7fca2d3bbf74fe614e02075d0419f2507d68efa53de4988605893271a2bc3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4889a8a780e94f221537499a77fdf5dc61bea3bae90d1a6b2bccad1ecabe93d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "477182536288c65e8300da8531287d1a85462012ed5040881c73a8f414737867"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "477182536288c65e8300da8531287d1a85462012ed5040881c73a8f414737867"
    sha256 cellar: :any_skip_relocation, sonoma:         "2561ffce2fa33e15ff6f8fb8753b3bf0c1df2637e02c0b9e4c0d47fcd9fd766b"
    sha256 cellar: :any_skip_relocation, ventura:        "ba3fa4e68304b091a5fb0a06be792298d19bbca7c637546933ce4cee8f796607"
    sha256 cellar: :any_skip_relocation, monterey:       "ba3fa4e68304b091a5fb0a06be792298d19bbca7c637546933ce4cee8f796607"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb1a8045434705a32ff62b8f7cb5dc73d25d42e30aa54efec091e79a371c1e3f"
  end

  uses_from_macos "file-formula" => :test
  uses_from_macos "perl"

  # NOTE: Getopt::Long is included with Perl. Archive::Zip is included with macOS

  resource "Archive::Cpio" do
    url "https://cpan.metacpan.org/authors/id/P/PI/PIXEL/Archive-Cpio-0.10.tar.gz"
    sha256 "246fb31669764e78336b2191134122e07c44f2d82dc4f37d552ab28f8668bed3"
  end

  resource "Archive::Zip" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/P/PH/PHRED/Archive-Zip-1.68.tar.gz"
      sha256 "984e185d785baf6129c6e75f8eb44411745ac00bf6122fb1c8e822a3861ec650"
    end
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    ENV.prepend_path "PERL5LIB", libexec/"lib"

    resources.each do |r|
      r.stage do
        if File.exist?("Makefile.PL")
          system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}", "NO_MYMETA=1"
          system "make", "install"
        else
          system "perl", "Build.PL", "--install_base", libexec
          system "./Build"
          system "./Build", "install"
        end
      end
    end

    system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
    system "make"
    system "make", "install"

    (bin/"strip-nondeterminism").write_env_script libexec/"bin/strip-nondeterminism", PERL5LIB: ENV["PERL5LIB"]
    man1.install_symlink libexec/"man/man1/strip-nondeterminism.1"
  end

  test do
    (testpath/"test.txt").write "Hello world"
    system "gzip", "test.txt"
    system bin/"strip-nondeterminism", "--timestamp", "1", "--verbose", "test.txt.gz"
    assert_match(/Thu\s+Jan\s+1\s+00:00:01\s+1970/, shell_output("file test.txt.gz"))
  end
end
