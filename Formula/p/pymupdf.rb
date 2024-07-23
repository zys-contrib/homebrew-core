class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://pymupdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/2e/30/dccf3e5bb35ca217fa64600fc4e2ceffd87576cb1c5f3c367f9cc422fa9a/PyMuPDF-1.24.8.tar.gz"
  sha256 "51c522e5824adf2317d17cf397daf9393792087a4ec772214011c11335073d6b"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d2a3f10e5baae3d875abdca306dee174005678b2c434bda91d078397c23a8750"
    sha256 cellar: :any,                 arm64_ventura:  "5c0d8476de88622f4f1b4e841906c3baa522c36b35324bba95fa20f1678bbfd8"
    sha256 cellar: :any,                 arm64_monterey: "202d9bb9f63fa2eb13791ca51e846990f341b1b0294dc481faf054d480c4f999"
    sha256 cellar: :any,                 sonoma:         "179e01413aaebf796430cc0299de30c50d16545cfb073267ac929eb9971b4b4c"
    sha256 cellar: :any,                 ventura:        "d421f7d12aef093e46dbefe77d0b304804edbe7430d34811370141c96ee31730"
    sha256 cellar: :any,                 monterey:       "ea29f5bd2fed27fb2f3ee3a8381763c598a5661417071966a1ab26e87b56f1c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e772d9e5fdb3c3ff90253c4a89546200b0a7a828aa9d69f5155658ae52da1c96"
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
    url "https://files.pythonhosted.org/packages/f8/8e/0c46a62a02cb5f264957e5ab0315ec5aaa276616f0143084601f48dac9be/PyMuPDFb-1.24.8.tar.gz"
    sha256 "fd18b791be7632bccd3fb9138bb2f732db4ca0f06ebb92eec5c8ec9f52836c74"
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
