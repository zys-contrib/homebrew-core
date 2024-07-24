class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://pymupdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/09/48/862dcbe3cc3f11394c2fc9c5021bf8023b4c917213b63553fb8f15764c95/PyMuPDF-1.24.9.tar.gz"
  sha256 "3692a5e824f10dc09bbddabab207f7cd5979831e48dd2f4de1be21e441767473"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2b74300882e6f26b5a4ac63f56c89add88f2ffcb6a7ac765bef5b5102ac21f2e"
    sha256 cellar: :any,                 arm64_ventura:  "28ba3fb7efd169db0b965823e6d0aaaea4c311bca4e3a8ba2c6c84ef54199eb9"
    sha256 cellar: :any,                 arm64_monterey: "c3b26ec16119deead75f3ad89aebe4cfab397f9cbb84331bd42204800f8db0ff"
    sha256 cellar: :any,                 sonoma:         "f46448ed2fe4a1dd6e30b861eb7a2558cb5bb63ad44e29da3aa824525e317e92"
    sha256 cellar: :any,                 ventura:        "9132be15d434f3a13a0d42e4a38df9d8561f5b064b40ae9d29b96f65fe40ef97"
    sha256 cellar: :any,                 monterey:       "a4cf601bef80e64672715427958e9dd88bede83967e6f5fb90644708efd9bb6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6c4e4c06d04921b4e0458e254ad7fa3a5a1fa3adccb250450b23003cf789db6"
  end

  depends_on "freetype" => :build
  depends_on "python-setuptools" => :build
  depends_on "swig" => :build
  depends_on "mupdf"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  resource "pymupdfb" do
    url "https://files.pythonhosted.org/packages/0c/6c/1d3e88cd7b6a0f074ad6cec0dc32f9c023acd98b328eb23a183517e80e2b/PyMuPDFb-1.24.9.tar.gz"
    sha256 "5505f07b3dded6e791ab7d10d01f0687e913fc75edd23fdf2825a582b6651558"
  end

  def install
    # Makes setup skip build stage for mupdf
    # https://github.com/pymupdf/PyMuPDF/blob/1.20.0/setup.py#L447
    ENV["PYMUPDF_SETUP_MUPDF_BUILD"] = ""
    # Builds only classic implementation
    # https://github.com/pymupdf/PyMuPDF/issues/2628
    ENV["PYMUPDF_SETUP_IMPLEMENTATIONS"] = "a"
    ENV["PYMUPDF_INCLUDES"] = "#{Formula["mupdf"].opt_include}:#{Formula["freetype"].opt_include}/freetype2"
    ENV["PYMUPDF_MUPDF_LIB"] = Formula["mupdf"].opt_lib.to_s

    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    (testpath/"test.py").write <<~EOS
      import sys
      from pathlib import Path

      # per 1.23.9 release, `fitz` module got renamed to `fitz_old`
      import fitz_old as fitz

      in_pdf = sys.argv[1]
      out_png = sys.argv[2]

      # Convert first page to PNG
      pdf_doc = fitz.open(in_pdf)
      pdf_page = pdf_doc.load_page(0)
      png_bytes = pdf_page.get_pixmap().tobytes()

      Path(out_png).write_bytes(png_bytes)
    EOS

    in_pdf = test_fixtures("test.pdf")
    out_png = testpath/"test.png"

    system python3, testpath/"test.py", in_pdf, out_png
    assert_predicate out_png, :exist?
  end
end
