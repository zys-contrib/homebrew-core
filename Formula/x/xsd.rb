class Xsd < Formula
  desc "XML Data Binding for C++"
  homepage "https://www.codesynthesis.com/products/xsd/"
  url "https://www.codesynthesis.com/download/xsd/4.2/xsd-4.2.0.tar.gz"
  sha256 "2bed17c601cfb984f9a7501fd5c672f4f18eac678f5bdef6016971966add9145"
  license "GPL-2.0-only" => { with: "Classpath-exception-2.0" }

  livecheck do
    url "https://www.codesynthesis.com/products/xsd/download.xhtml"
    regex(/href=.*?xsd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8119ae88416a48f44f45d39b54d6c14b8849bae8fed840a0e88456c7c2bff144"
    sha256 cellar: :any,                 arm64_sonoma:  "a36a30cf1bdff08460969ddcc24fae52a5cc743d57253c564d4d89a828f4db64"
    sha256 cellar: :any,                 arm64_ventura: "4f2eb34d577abf123990d70c6ee5ff4b8d77e53778260f4b93325f68941d3e33"
    sha256 cellar: :any,                 sonoma:        "a0154c4c947ed3117bc4c45530a90a4ff2ac6c9d748472371b955119dfac9363"
    sha256 cellar: :any,                 ventura:       "5f941b47bc3bbd36bd6282e3d580f123056768597b66397e308e7aac5b991b09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1617579f8c28bfe87fcb4a1630a34700bcf0266bb4a179969e49fcc62fde4eed"
  end

  depends_on "build2" => :build
  depends_on "libcutl"
  depends_on "libxsd-frontend"
  depends_on "xerces-c"

  conflicts_with "mono", because: "both install `xsd` binaries"

  resource "libxsd" do
    url "https://www.codesynthesis.com/download/xsd/4.2/libxsd-4.2.0.tar.gz"
    sha256 "55caf0038603883eb39ac4caeaacda23a09cf81cffc8eb55a854b6b06ef2c52e"
  end

  def install
    odie "`libxsd` resource needs to be updated!" if version != resource("libxsd").version

    system "b", "configure", "config.cc.loptions=-L#{HOMEBREW_PREFIX}/lib", "config.install.root=#{prefix}"
    system "b", "install", "--jobs=#{ENV.make_jobs}", "-V"

    resource("libxsd").stage do
      system "b", "configure", "config.install.root=#{prefix}"
      system "b", "install", "--jobs=#{ENV.make_jobs}", "-V"
    end
  end

  test do
    (testpath/"meaningoflife.xsd").write <<~XSD
      <?xml version="1.0" encoding="UTF-8"?>
      <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" elementFormDefault="qualified"
                 targetNamespace="https://brew.sh/XSDTest" xmlns="https://brew.sh/XSDTest">
        <xs:element name="MeaningOfLife" type="xs:positiveInteger"/>
      </xs:schema>
    XSD

    (testpath/"meaningoflife.xml").write <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <MeaningOfLife xmlns="https://brew.sh/XSDTest" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                     xsi:schemaLocation="https://brew.sh/XSDTest meaningoflife.xsd">
        42
      </MeaningOfLife>
    XML

    (testpath/"xsdtest.cxx").write <<~EOS
      #include <cassert>
      #include "meaningoflife.hxx"
      int main (int argc, char *argv[]) {
        assert(2==argc);
        std::unique_ptr<::xml_schema::positive_integer> x = XSDTest::MeaningOfLife(argv[1]);
        assert(42==*x);
        return 0;
      }
    EOS

    system bin/"xsd", "cxx-tree", "meaningoflife.xsd"
    assert_path_exists testpath/"meaningoflife.hxx"
    assert_path_exists testpath/"meaningoflife.cxx"

    system ENV.cxx, "-std=c++11", "xsdtest.cxx", "meaningoflife.cxx", "-o", "xsdtest",
                    "-L#{Formula["xerces-c"].opt_lib}", "-lxerces-c"
    system "./xsdtest", "meaningoflife.xml"
  end
end
