class Pillow < Formula
  desc "Friendly PIL fork (Python Imaging Library)"
  homepage "https://python-pillow.github.io/"
  url "https://files.pythonhosted.org/packages/af/cb/bb5c01fcd2a69335b86c22142b2bccfc3464087efb7fd382eee5ffc7fdf7/pillow-11.2.1.tar.gz"
  sha256 "a64dd61998416367b7ef979b73d3a85853ba9bec4c2925f74e588879a58716b6"
  license "HPND"
  head "https://github.com/python-pillow/Pillow.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "5d49ed0a569baa6f8ab2ed69e298922986b3594a4ad76fccc964e8155b79a59a"
    sha256 cellar: :any, arm64_sonoma:  "b68e9e35e9f90f5d48086c7e50b74e2f5db18c9ff0661fe9a644cd24e3c3a977"
    sha256 cellar: :any, arm64_ventura: "8dbac4d14ba6f12abe29a96bea760d2623078b317300ee3230f18c102e7d85d8"
    sha256 cellar: :any, sonoma:        "5d3f32665e5228bdef42573b35c94aecee1a34446acd562ae10599bdc4a900fc"
    sha256 cellar: :any, ventura:       "f5c9181ce709dd44815a7dc56b2fe670bffefc033e9df7f0c9fa5286836e0cee"
    sha256               arm64_linux:   "1baa91480197d64d621576297e1accde3c6a5a587893670a82982eac51adc985"
    sha256               x86_64_linux:  "d19161ff9a9c0cf9d660d05761bac9450d4a5086c9f54d7bb6ac7fe327e401fd"
  end

  depends_on "pkgconf" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "python@3.13" => [:build, :test]
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libimagequant"
  depends_on "libraqm"
  depends_on "libtiff"
  depends_on "libxcb"
  depends_on "little-cms2"
  depends_on "openjpeg"
  depends_on "webp"

  uses_from_macos "zlib"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    ENV["MAX_CONCURRENCY"] = ENV.make_jobs.to_s
    deps.each do |dep|
      next if dep.build? || dep.test?

      ENV.prepend "CPPFLAGS", "-I#{dep.to_formula.opt_include}"
      ENV.prepend "LDFLAGS", "-L#{dep.to_formula.opt_lib}"
    end

    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args(build_isolation: true),
                     "-C", "debug=true", # Useful in case of build failures.
                     "-C", "tiff=enable",
                     "-C", "freetype=enable",
                     "-C", "lcms=enable",
                     "-C", "webp=enable",
                     "-C", "xcb=enable",
                     "."
    end
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      from PIL import Image
      im = Image.open("#{test_fixtures("test.jpg")}")
      print(im.format, im.size, im.mode)
    PYTHON

    pythons.each do |python|
      assert_equal "JPEG (1, 1) RGB", shell_output("#{python} test.py").chomp
    end
  end
end
