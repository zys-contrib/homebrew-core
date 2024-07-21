class Libdap < Formula
  desc "Framework for scientific data networking"
  homepage "https://www.opendap.org/"
  url "https://www.opendap.org/pub/source/libdap-3.21.0-27.tar.gz"
  sha256 "b5b8229d3aa97fea9bba4a0b11b1ee1c6446bd5f7ad2cff591f86064f465eacf"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://www.opendap.org/pub/source/"
    regex(/href=.*?libdap[._-]v?(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "c8a5f36b1d1599554e7523671dc192a2d0a444a8e2fcc0e73ca92a66af9843ed"
    sha256 arm64_ventura:  "c4655809997b644c2a9e628bf405a85b33681231830c5a08fee719ebc2794b09"
    sha256 arm64_monterey: "2a0cac8b856a1780abaabbf46b0de39682bb192eb3888ccf7e12eab1c2ffa8f0"
    sha256 arm64_big_sur:  "ee9caecec80a9df604ed8ba59c0c828548939f974b954003147f22ddeb49bb7b"
    sha256 sonoma:         "20f97a2b00c484efd26b7b184ce7d7165d130f9e01366dfb6a11fa9e6b96f7cb"
    sha256 ventura:        "4af8d55b4d9ce4e4bb3438c53f6530aa00819c3aa3410eaf67716afb3a81151e"
    sha256 monterey:       "24d228b526d5db23c022a523d7458fc90eb14f19c9c2a448904f6987dd6b9485"
    sha256 big_sur:        "6d117a85b5ab93b08e9bd688b52cff3df1a33205debe6d8924524405fe94eedf"
    sha256 x86_64_linux:   "99e9742d73185c98065998c20d97970f7a1044f42d87215745dbbb4a3f697722"
  end

  head do
    url "https://github.com/OPENDAP/libdap4.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "libxml2"
  depends_on "openssl@3"

  uses_from_macos "flex" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "libtirpc"
    depends_on "util-linux"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-debug
      --with-included-regex
    ]

    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"

    # Ensure no Cellar versioning of libxml2 path in dap-config entries
    xml2 = Formula["libxml2"]
    inreplace bin/"dap-config", xml2.opt_prefix.realpath, xml2.opt_prefix
  end

  test do
    # Versions like `1.2.3-4` simply appear appear as `1.2.3` in the output,
    # so we have to remove the suffix from the formula version.
    assert_match version.to_s.sub(/-\d+$/, ""), shell_output("#{bin}/dap-config --version")
  end
end
