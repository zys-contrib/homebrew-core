class OilsForUnix < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://www.oilshell.org/"
  url "https://www.oilshell.org/download/oils-for-unix-0.22.0.tar.gz"
  sha256 "7ad64ad951faa9b8fd310fc17df0a93291e041ab75311aca1bc85cbbfa7ad45f"
  license "Apache-2.0"

  livecheck do
    url "https://www.oilshell.org/releases.html"
    regex(/href=.*?oils-for-unix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  depends_on "readline"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--datarootdir=#{share}",
                          "--readline=#{Formula["readline"].opt_prefix}",
                          "--with-readline"
    system "_build/oils.sh"
    system "./install"
  end

  test do
    system "#{bin}/osh", "-c", "shopt -q parse_backticks"
    assert_equal testpath.to_s, shell_output("#{bin}/osh -c 'echo `pwd -P`'").strip

    system "#{bin}/ysh", "-c", "shopt -u parse_equals"
    assert_equal "bar", shell_output("#{bin}/ysh -c 'var foo = \"bar\"; write $foo'").strip
  end
end
