class Scheme48 < Formula
  desc "Scheme byte-code interpreter"
  homepage "https://www.s48.org/"
  url "https://s48.org/1.9.3/scheme48-1.9.3.tgz"
  sha256 "6ef5a9f3fca14110b0f831b45801d11f9bdfb6799d976aa12e4f8809daf3904c"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/download\.html}i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia:  "a24724c149c3e2954fc468093432e63fb1306fa6e545d3e06f76790697f9bf1f"
    sha256 arm64_sonoma:   "e0657af21f8db5bff943e21c608082e06d68161b2025354af2c6cee675a7f1fb"
    sha256 arm64_ventura:  "cc137fe1119517b408d4c7d7667663be60379276926b784615e39a0895f297ee"
    sha256 arm64_monterey: "c20ad35da984e79e5a9fda348b2c1f9eea887926bd5a5078c9a489e7e93b9204"
    sha256 arm64_big_sur:  "5a2ff16cfe2c0cad8648b4057552a19f3389408d3e90b884c0b4d4f3c4116d30"
    sha256 sonoma:         "b28de7ec2a5c09b39cb5dc14d3d572968f9a53d3aced77401879a76c1106c4bf"
    sha256 ventura:        "12112675043f26739fdbefb483030cee2917a8672955f4ac605ad7a07a35300d"
    sha256 monterey:       "4856f33cf05dadebca3d0114e9784a48e6864244653adfdc81fde92f6f90e0f4"
    sha256 big_sur:        "c11d8062b6115384d18f174cd7f5ce5fef434b3ed35b914b85a7c9df041cc450"
    sha256 catalina:       "50398406b73f7b6b5ce3c0f220694673e42b83bd63f11149a855498e4caf3c94"
    sha256 mojave:         "42cacccaf71990813012cdc819702fe24a93555998ac86d54e389ea40f6f2a87"
    sha256 high_sierra:    "590f06c7c31910eed48da06080959628982226e7b09e2aedd352fa6e4a6c2007"
    sha256 sierra:         "e9751df2e3cfd1a007d74d541ca494a439645e3006ad354ddf65b0abfb370864"
    sha256 el_capitan:     "af2ced8a13fdad5478f745c698b09071e71d84daca01c6e3e3c35961b06cbea4"
    sha256 x86_64_linux:   "522dcf810f30c5e1f91fae01d951764ece1b12edaf42a497c31a87539831168d"
  end

  conflicts_with "gambit-scheme", because: "both install `scheme-r5rs` binaries"

  # remove doc installation step
  patch :DATA

  def install
    # Workaround for newer Clang
    ENV.append_to_cflags "-Wno-implicit-int" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", "--prefix=#{prefix}", "--enable-gc=bibop"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"hello.scm").write <<~EOS
      (display "Hello, World!") (newline)
    EOS

    expected = <<~EOS
      Hello, World!\#{Unspecific}

      \#{Unspecific}

    EOS

    assert_equal expected, shell_output("#{bin}/scheme48 -a batch < hello.scm")
  end
end

__END__
diff --git a/Makefile.in b/Makefile.in
index 5fce20d..1647047 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -468,7 +468,7 @@ doc/manual.ps: $(MANUAL_SRC)
 doc/html/manual.html: doc/manual.pdf
 	cd $(srcdir)/doc/src && tex2page manual && tex2page manual && tex2page manual

-doc: doc/manual.pdf doc/manual.ps doc/html/manual.html
+doc: # doc/manual.pdf doc/manual.ps doc/html/manual.html

 install: install-no-doc install-doc
