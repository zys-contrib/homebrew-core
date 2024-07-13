class Ftnchek < Formula
  desc "Fortran 77 program checker"
  homepage "https://www.dsm.fordham.edu/~ftnchek/"
  url "https://www.dsm.fordham.edu/~ftnchek/download/ftnchek-3.3.1.tar.gz"
  sha256 "d92212dc0316e4ae711f7480d59e16095c75e19aff6e0095db2209e7d31702d4"
  license "MIT"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  on_system :linux, macos: :ventura_or_newer do
    depends_on "groff" => :build
  end

  def install
    # Fix outdated host platform detection (use x86_64 and aarch64 instead
    # of i686 and arm, respectively)
    system "autoreconf", "--force", "--install", "--verbose"

    args = []

    # When building using brewed soelim (part of groff), the configure
    # script does not properly detect the path to soelim, so set it explicitly.
    args << "SOELIM=#{Formula["groff"].opt_bin}/soelim" if OS.linux? || (OS.mac? && MacOS.version >= :ventura)

    # Exclude unrecognized options
    args += std_configure_args.reject { |s| s["--disable-debug"] || s["--disable-dependency-tracking"] }

    system "./configure", *args
    system "make", "install"
  end

  test do
    # In fixed format Fortran 77, all lines of code starts 7th (or further)
    # column. The first 6 columns are reserved for labels, continuation
    # chars, etc.
    indent = " " * 6
    (testpath/"hello.f77").write <<~EOS
      #{indent}PROGRAM HELLOW
      #{indent}WRITE(UNIT=*, FMT=*) 'Hello World'
      #{indent}END
    EOS

    (testpath/"empty.f77").write ""

    assert_match "0 syntax errors detected in file hello.f77",
                 shell_output("#{bin}/ftnchek hello.f77")
    assert_match "No main program found",
                 shell_output("#{bin}/ftnchek empty.f77")
  end
end
