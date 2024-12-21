class GnuTypist < Formula
  desc "GNU typing tutor"
  homepage "https://www.gnu.org/software/gtypist/"
  url "https://ftp.gnu.org/gnu/gtypist/gtypist-2.10.tar.xz"
  mirror "https://ftpmirror.gnu.org/gtypist/gtypist-2.10.tar.xz"
  sha256 "f1e79cd95742c84c6d035f6d8f393a2a1be0e00b1c016a22462df16d6667562c"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_sequoia:  "d5d21482cbcca6dbe6e311f9200daab62ab86752bb59ad28b83c63eec32d7754"
    sha256 arm64_sonoma:   "ec0daf0f5a1f0ceae0482b59a88ad8d24489c5d04334f36f052afff193dd47be"
    sha256 arm64_ventura:  "4ea5b5536d71dcce549c137487e1f253de1c65eb731cc96f96c6f840552538a2"
    sha256 arm64_monterey: "55bc014edf3a03938527035d043b5f993d9574e0b77a9ecd6d332eb4e8efcd18"
    sha256 sonoma:         "5994bfad16531f2491e6749b2bc1219f1a20e1f9c46713d3dedef188b66c00d8"
    sha256 ventura:        "63a4ab5d80a451ac4a64c4f8210d6fef5be03ed16ce91d121d3f6054f9b60dc9"
    sha256 monterey:       "9176597b6394a63864ef693f4815b74930a63f245a36b66656e9f203bf49d509"
    sha256 x86_64_linux:   "a992581b5efb631c92abb7b43ac1f126acb16fda1479beff3fd137276a04197f"
  end

  depends_on "gettext"

  uses_from_macos "ncurses"

  # Use Apple's ncurses instead of ncursesw.
  # TODO: use an IFDEF for apple and submit upstream
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/b5593da4ce6302d9ccaef9fde52bf60a6d4a669b/gnu-typist/2.10.patch"
    sha256 "26e0576906f42b76db8f7592f1b49fabd268b2af49c212a48a4aeb2be41551b3"
  end

  def install
    # libiconv is not linked properly without this
    ENV.append "LDFLAGS", "-liconv" if OS.mac?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-lispdir=#{elisp}"
    system "make"
    system "make", "install"
  end

  test do
    session = fork do
      exec bin/"gtypist", "-t", "-q", "-l", "DEMO_0", share/"gtypist/demo.typ"
    end
    sleep 2
    Process.kill("TERM", session)
  end
end
