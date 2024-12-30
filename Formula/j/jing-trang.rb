class JingTrang < Formula
  desc "Schema validation and conversion based on RELAX NG"
  homepage "http://www.thaiopensource.com/relaxng/"
  url "https://github.com/relaxng/jing-trang.git",
      tag:      "V20241231",
      revision: "a6bc0041035988325dfbfe7823ef2c098fc56597"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "655ca3e056c02320bec6666cf23d0919919dbc2dfa773d8c5a90b6cbae8d2d4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2837d6e749b7472a799cd9e9b297481dc130413e94619b5dd0e925529f28fa4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f549de984955fcd37dffa2150003e73e3b3d52b48618552a26c751d912b901e"
    sha256 cellar: :any_skip_relocation, sonoma:        "49209567f775806905b0eb6d363269152fdfb3a1ad6908a47d6f86a39d7c6f75"
    sha256 cellar: :any_skip_relocation, ventura:       "739b24553e45e2334ddf28a8b47308fed802a837cf1d6415c0c03dd04776ce3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a54f2baff24efaf490090bc6965604f67b5f9352a3e9d6a28745037b14519be6"
  end

  depends_on "ant" => :build
  depends_on "openjdk@11"

  uses_from_macos "unzip" => :build

  def install
    ENV["JAVA_HOME"] = Formula["openjdk@11"].opt_prefix
    system "./ant", "jing-dist"
    system "./ant", "trang-dist"
    system "unzip", "-o", "-d", "build/dist", "build/dist/jing-#{version}.zip"
    system "unzip", "-o", "-d", "build/dist", "build/dist/trang-#{version}.zip"
    libexec.install Dir["build/dist/jing-#{version}"]
    libexec.install Dir["build/dist/trang-#{version}"]
    bin.write_jar_script libexec/"jing-#{version}/bin/jing.jar", "jing", java_version: "11"
    bin.write_jar_script libexec/"trang-#{version}/trang.jar", "trang", java_version: "11"
  end

  test do
    (testpath/"test.rnc").write <<~EOS
      namespace core = "http://www.bbc.co.uk/ontologies/coreconcepts/"
      start = response
      response = element response { results }
      results = element results { thing* }

      thing = element thing {
        attribute id { xsd:string } &
        element core:preferredLabel { xsd:string } &
        element core:label { xsd:string &  attribute xml:lang { xsd:language }}* &
        element core:disambiguationHint { xsd:string }? &
        element core:slug { xsd:string }?
      }
    EOS
    (testpath/"test.xml").write <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <response xmlns:core="http://www.bbc.co.uk/ontologies/coreconcepts/">
        <results>
          <thing id="https://www.bbc.co.uk/things/31684f19-84d6-41f6-b033-7ae08098572a#id">
            <core:preferredLabel>Technology</core:preferredLabel>
            <core:label xml:lang="en-gb">Technology</core:label>
            <core:label xml:lang="es">Tecnología</core:label>
            <core:label xml:lang="ur">ٹیکنالوجی</core:label>
            <core:disambiguationHint>News about computers, the internet, electronics etc.</core:disambiguationHint>
          </thing>
          <thing id="https://www.bbc.co.uk/things/0f469e6a-d4a6-46f2-b727-2bd039cb6b53#id">
            <core:preferredLabel>Science</core:preferredLabel>
            <core:label xml:lang="en-gb">Science</core:label>
            <core:label xml:lang="es">Ciencia</core:label>
            <core:label xml:lang="ur">سائنس</core:label>
            <core:disambiguationHint>Systematic enterprise</core:disambiguationHint>
          </thing>
        </results>
      </response>
    XML

    system bin/"jing", "-c", "test.rnc", "test.xml"
    system bin/"trang", "-I", "rnc", "-O", "rng", "test.rnc", "test.rng"
  end
end
