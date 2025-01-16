class GuileFibers < Formula
  desc "Concurrent ML-like concurrency for Guile"
  homepage "https://github.com/wingo/fibers"
  url "https://github.com/wingo/fibers/releases/download/v1.3.1/fibers-1.3.1.tar.gz"
  sha256 "a5e1a9c49c0efe7ac6f355662041430d4b64e59baa538d2b8fb5ef7528d81dbf"
  license "LGPL-3.0-or-later"

  depends_on "guile"
  depends_on "libevent"

  on_macos do
    depends_on "bdw-gc"
  end

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = share/"guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = lib/"guile/3.0/site-ccache"

    (testpath/"test-fibers.scm").write <<~SCHEME
      (use-modules (fibers))
      (display "fibers loaded\\n")
    SCHEME

    output = shell_output("guile test-fibers.scm")
    assert_match "fibers loaded", output
  end
end
