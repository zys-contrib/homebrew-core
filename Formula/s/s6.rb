class S6 < Formula
  desc "Small & secure supervision software suite"
  homepage "https://skarnet.org/software/s6/"
  url "https://skarnet.org/software/s6/s6-2.13.2.0.tar.gz"
  sha256 "c5114b8042716bb70691406931acb0e2796d83b41cbfb5c8068dce7a02f99a45"
  license "ISC"

  livecheck do
    url :homepage
    regex(/href=.*?s6[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67e7b84ebe8f1610f2edeba0bfafb362eb0c6f8fc9bd2e31bbc777ebf384840f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81cb72f4806fb26f29f6537da49a1c5e7fcccdaa8a8a34d7d878ef3e19e7803c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c59164a75b08590c40b69598f6d846230fe8288de366c5d371f8f7e3d276446a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f282796bae69dd7ccc641601060115edec8bdf4f95889492574725e07eb566c7"
    sha256 cellar: :any_skip_relocation, ventura:       "f985eafa60d7504a2efd641f591189a88467444ccf528a5ef9301ee369bec659"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec4890a947f1e2aa3363969112a8f80ca3f3bdf647c9ede8fd74a39cb4ec213a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a50281696347be24e9cbfc2a0beb51ad926bdc10bf8efb86b55e57ee3d6afd4c"
  end

  depends_on "pkgconf" => :build
  depends_on "execline"
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
    (testpath/"log").mkpath
    pipe_output("#{bin}/s6-log #{testpath}/log", "Test input\n", 0)
    assert_equal "Test input\n", File.read(testpath/"log/current")
  end
end
