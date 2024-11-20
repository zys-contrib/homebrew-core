class LibxsdFrontend < Formula
  desc "Compiler frontend for the W3C XML Schema definition language"
  homepage "https://www.codesynthesis.com/projects/libxsd-frontend/"
  url "https://www.codesynthesis.com/download/xsd/4.2/libxsd-frontend-2.1.0.tar.gz"
  sha256 "98321b9c2307d7c4e1eba49da6a522ffa81bdf61f7e3605e469aa85bfcab90b1"
  license "GPL-2.0-only"

  depends_on "build2" => :build
  depends_on "libcutl"
  depends_on "xerces-c"

  def install
    system "b", "configure", "config.cc.loptions=-L#{HOMEBREW_PREFIX}/lib", "config.install.root=#{prefix}"
    system "b", "install", "--jobs=#{ENV.make_jobs}", "-V"
    pkgshare.install "tests/schema/driver.cxx" => "test.cxx"
  end

  test do
    (testpath/"test.xsd").write <<~XSD
      <?xml version="1.0" encoding="UTF-8"?>
      <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" elementFormDefault="qualified"
                 targetNamespace="https://brew.sh/XSDTest" xmlns="https://brew.sh/XSDTest">
        <xs:element name="MeaningOfLife" type="xs:positiveInteger"/>
      </xs:schema>
    XSD

    system ENV.cxx, "-std=c++11", pkgshare/"test.cxx", "-o", "test",
                    "-L#{lib}", "-lxsd-frontend", "-L#{Formula["libcutl"].opt_lib}", "-lcutl"
    assert_equal <<~TEXT, shell_output("./test test.xsd")
      primary
      {
        namespace https://brew.sh/XSDTest
        {
          element MeaningOfLife http://www.w3.org/2001/XMLSchema#positiveInteger
        }
      }
    TEXT
  end
end
