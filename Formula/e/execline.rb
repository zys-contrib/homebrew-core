class Execline < Formula
  desc "Interpreter-less scripting language"
  homepage "https://skarnet.org/software/execline/"
  url "https://skarnet.org/software/execline/execline-2.9.7.0.tar.gz"
  sha256 "73c9160efc994078d8ea5480f9161bfd1b3cf0b61f7faab704ab1898517d0207"
  license "ISC"

  depends_on "pkgconf" => :build
  depends_on "skalibs"

  def install
    # Shared libraries are linux targets and not supported on macOS.
    args = %W[
      --disable-silent-rules
      --disable-shared
      --enable-pkgconfig
      --with-pkgconfig=#{Formula["pkgconf"].opt_bin}/pkg-config
      --with-sysdeps=#{Formula["skalibs"].opt_lib}/skalibs/sysdeps
    ]
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.eb").write <<~EOS
      foreground
      {
        sleep 1
      }
      "echo"
      "Homebrew"
    EOS
    assert_match "Homebrew", shell_output("#{bin}/execlineb test.eb")
  end
end
