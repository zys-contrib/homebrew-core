class Argus < Formula
  desc "Audit Record Generation and Utilization System server"
  homepage "https://openargus.org"
  url "https://github.com/openargus/argus/archive/refs/tags/v5.0.0.tar.gz"
  sha256 "d2ac1013832ba502570ce4a152c02c898e3725b8682e21af54d8e3a513c3396e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0595c742b712da37d23a83158bfe73f730d11b47769a01334583eb1b1f7d0491"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c77cf2ebf326271560f9ab2bc5e50889133cc8ea1a39c5a719b4016710c3c764"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1b3fe3a7c3dd11ee63dbca00091b02d68f821087efb4343ce4136137c36295e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3b0421c50d060c2f6812a9b10ee5121336f80306a96271819737903ec98574c"
    sha256 cellar: :any_skip_relocation, sonoma:         "79236cadc1973ea8f2294f159e825a0645e3414da0ee7461c10c49811fb86c44"
    sha256 cellar: :any_skip_relocation, ventura:        "45ecaf9689f988463d3971f73d5da0c0401d2818bbef025cb06f818f15f8a3db"
    sha256 cellar: :any_skip_relocation, monterey:       "8482631be1b4bd57043075c0dc9d05f54c6188eab3119f91a88c239f59eda4ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "c33edf660a14aa03704fe3efda1fb1282b70b127fe881a2402cfa0360a9ea86d"
    sha256 cellar: :any_skip_relocation, catalina:       "8deffdef21a05cf61e3b134532439173966ec8748f1988c4048c3173d6788d2e"
    sha256 cellar: :any_skip_relocation, mojave:         "83ea7bc0f0103ba900dad6856762aae355f726c0bb9f089cc5434c30dacce1fb"
    sha256 cellar: :any_skip_relocation, high_sierra:    "faf6ef808e9ff867eed42586ae6c27f84b66933559e9960fb48853b67325fb20"
    sha256 cellar: :any_skip_relocation, sierra:         "42487c51fa731752e10da402b5fac0f973ee090eaad19f8f4fd52fc5317c9cfb"
    sha256 cellar: :any_skip_relocation, el_capitan:     "ea46f2010610e46c120e2df100d61e01c21ee58627e105273c0e0a76437150e1"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "cyrus-sasl"
  uses_from_macos "libpcap"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libtirpc"
  end

  def install
    if OS.linux?
      ENV.append_to_cflags "-I#{Formula["libtirpc"].opt_include}/tirpc"
      ENV.append "LIBS", "-ltirpc"
    end
    system "./configure", "--with-sasl", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Pages", shell_output(bin/"argus-vmstat") if OS.mac?
    assert_match "Argus Version #{version}", shell_output("#{sbin}/argus -h", 255)
    system sbin/"argus", "-r", test_fixtures("test.pcap"), "-w", testpath/"test.argus"
    assert_predicate testpath/"test.argus", :exist?
  end
end
