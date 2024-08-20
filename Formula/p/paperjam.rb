class Paperjam < Formula
  desc "Program for transforming PDF files"
  homepage "https://mj.ucw.cz/sw/paperjam/"
  url "https://mj.ucw.cz/download/linux/paperjam-1.2.1.tar.gz"
  sha256 "bd38ed3539011f07e8443b21985bb5cd97c656e12d9363571f925d039124839b"
  license "GPL-2.0-or-later"

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build
  depends_on "libpaper"
  depends_on "qpdf"
  uses_from_macos "libxslt"

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    ENV.append "LDLIBS", "-liconv" if OS.mac?
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"paperjam", "modulo(2) { 1, 2: rotate(180) }", test_fixtures("test.pdf"), "output.pdf"
    assert_predicate testpath/"output.pdf", :exist?
  end
end
