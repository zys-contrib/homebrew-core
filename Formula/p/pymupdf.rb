class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://pymupdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/22/39/84efca63af4e5a014c1d4c21686469f99c3d1c160a3a0b902ac676f6ffd9/PyMuPDF-1.24.13.tar.gz"
  sha256 "6ec3ab3c6d5cba60bfcf58daaa2d1a5b700b0366ce52be666445007351461fa4"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "674d1b92006b1944b578e46f0fb9709bcad28950dd9da1f45f92577b17ae7e36"
    sha256 cellar: :any,                 arm64_sonoma:  "74f451f1704afee393408735646f4b683ecf39d752bd1148e8561219904da079"
    sha256 cellar: :any,                 arm64_ventura: "c2fcdaa02d6187f0eee6a16ec40df0eea4a73d6eb58c3f93aea16ba4b88e01ae"
    sha256 cellar: :any,                 sonoma:        "2a87b62eb6112d0a2c792000dd904c66d49a420dbf6c59207feabaee282a2973"
    sha256 cellar: :any,                 ventura:       "d52b0f3f6de5715d8140852f344d82df4fc5cd7a233f54b26fc7a9f2811c92e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fb54dc9d4023fd5927ab00a906716c8ff084d45e97238af42923bc0c3b07e60"
  end

  depends_on "freetype" => :build
  depends_on "python-setuptools" => :build
  depends_on "swig" => :build
  depends_on "mupdf"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    # Makes setup skip build stage for mupdf
    # https://github.com/pymupdf/PyMuPDF/blob/1.20.0/setup.py#L447
    ENV["PYMUPDF_SETUP_MUPDF_BUILD"] = ""
    ENV["PYMUPDF_INCLUDES"] = "#{Formula["mupdf"].opt_include}:#{Formula["freetype"].opt_include}/freetype2"
    ENV["PYMUPDF_MUPDF_LIB"] = Formula["mupdf"].opt_lib.to_s

    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    (testpath/"test.py").write <<~EOS
      import sys
      from pathlib import Path

      import fitz

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
