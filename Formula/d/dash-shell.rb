class DashShell < Formula
  desc "POSIX-compliant descendant of NetBSD's ash (the Almquist SHell)"
  homepage "http://gondor.apana.org.au/~herbert/dash/"
  url "http://gondor.apana.org.au/~herbert/dash/files/dash-0.5.12.tar.gz"
  sha256 "6a474ac46e8b0b32916c4c60df694c82058d3297d8b385b74508030ca4a8f28a"
  license "BSD-3-Clause"
  head "https://git.kernel.org/pub/scm/utils/dash/dash.git", branch: "master"

  livecheck do
    url "http://gondor.apana.org.au/~herbert/dash/files/"
    regex(/href=.*?dash[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "libedit"

  def install
    ENV["ac_cv_func_stat64"] = "no" if OS.mac? && Hardware::CPU.arm?
    system "./autogen.sh" if build.head?
    system "./configure", "--with-libedit", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"dash", "-c", "echo Hello!"
  end
end
