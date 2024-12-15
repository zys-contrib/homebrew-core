class Tzdb < Formula
  desc "Time Zone Database"
  homepage "https://www.iana.org/time-zones"
  url "https://data.iana.org/time-zones/releases/tzdb-2024b.tar.lz"
  sha256 "22674a67786d3ec1b0547305904011cb2b9126166e72abbbea39425de5595233"
  license all_of: ["BSD-3-Clause", :public_domain]

  on_macos do
    depends_on "gettext"
  end

  def localtime
    etc/"localtime"
  end

  def install
    make_args = %W[
      CFLAGS=#{ENV.cflags}
      USRDIR=#{prefix}
      TZDEFAULT=#{localtime}
    ]
    if OS.mac?
      gettext = Formula["gettext"]
      make_args[0] += " -DHAVE_GETTEXT -I#{gettext.include} -L#{gettext.lib}"
      make_args << "LDLIBS=-lintl"
    end

    system "make", *make_args, "install"
  end

  def post_install
    # Generate default localtime, from Makefile.
    system sbin/"zic", "-l", "Factory", "-p", "-", "-t", localtime
  end

  test do
    assert_match "UTC", shell_output("#{bin}/zdump UTC")
  end
end
