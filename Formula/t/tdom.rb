class Tdom < Formula
  desc "XML/DOM/XPath/XSLT/HTML/JSON implementation for Tcl"
  homepage "https://tdom.org/"
  url "https://tdom.org/downloads/tdom-0.9.5-src.tgz"
  sha256 "ce22e3f42da9f89718688bf413b82fbf079b40252ba4dd7f2a0e752232bb67e8"
  license "MPL-2.0"

  depends_on "tcl-tk"

  def install
    system "./configure", "--disable-silent-rules", "--with-tcl=#{ENV["HOMEBREW_PREFIX"]}/lib", *std_configure_args
    system "make", "install"
  end

  test do
    test_tdom = <<~TCL
      if {[catch {
        package require tdom

        set xml {<?xml version="1.0"?>
          <root>
            <child>12345</child>
          </root>}

        set doc [dom parse $xml]
        set node [$doc selectNodes root/child/text()]
        if {[$node data] == "12345"} {
          puts "OK"
        }
      } resultVar]} {
        puts $resultVar
      }
    TCL

    assert_equal "OK", pipe_output("#{ENV["HOMEBREW_PREFIX"]}/bin/tclsh", test_tdom).chomp
  end
end
