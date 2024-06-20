class Imposm3 < Formula
  desc "Imports OpenStreetMap data into PostgreSQL/PostGIS databases"
  homepage "https://imposm.org"
  url "https://github.com/omniscale/imposm3/archive/refs/tags/v0.13.2.tar.gz"
  sha256 "a4edb7626d929919224c3778af5a2f2d11539a5d5c30fec00bacacbc39dfb7a0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "30ef32606ddac78c42e5d52aefd9d6ca72a400b0d69826c367a5f0cafe94a873"
    sha256 cellar: :any,                 arm64_ventura:  "1808dbf2b5b2155e12e02f47ebcb1e6254e819b8797cfa2abb76607e8d6fe9eb"
    sha256 cellar: :any,                 arm64_monterey: "ddb8fee6835acf08a9d79ac7a87e4071b80a795a2c49fda501625e34c448a4e4"
    sha256 cellar: :any,                 sonoma:         "9b58ea5975a1b0d6774aa9ce9587244272a9eb243d40e928b6e06566f71fcbf4"
    sha256 cellar: :any,                 ventura:        "4e3e0947c02b075789e38e11fcde31262968b2265f18cb6bb8bc0e095248d168"
    sha256 cellar: :any,                 monterey:       "acf0787117629c32e83c5c924c1d84dd82db964221aa88133d5bf26ee39e8c72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "464f3634ca660df286da7e1b249d9a592c6ac22e7a3c60b250440748132bced2"
  end

  depends_on "go" => :build
  depends_on "osmium-tool" => :test
  depends_on "geos"
  depends_on "leveldb"

  def install
    ENV["CGO_LDFLAGS"] = "-L#{Formula["geos"].opt_lib} -L#{Formula["leveldb"].opt_lib}"
    ENV["CGO_CFLAGS"] = "-I#{Formula["geos"].opt_include} -I#{Formula["leveldb"].opt_include}"

    ldflags = "-X github.com/omniscale/imposm3.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"imposm"), "cmd/imposm/main.go"
  end

  test do
    (testpath/"sample.osm.xml").write <<~EOS
      <?xml version='1.0' encoding='UTF-8'?>
      <osm version="0.6">
        <bounds minlat="51.498" minlon="7.579" maxlat="51.499" maxlon="7.58"/>
      </osm>
    EOS

    (testpath/"mapping.yml").write <<~EOS
      tables:
        admin:
          columns:
          - name: osm_id
            type: id
          - name: geometry
            type: geometry
          - key: name
            name: name
            type: string
          - name: type
            type: mapping_value
          - key: admin_level
            name: admin_level
            type: integer
          mapping:
            boundary:
            - administrative
          type: polygon
    EOS

    assert_match version.to_s, shell_output("#{bin}/imposm version").chomp

    system "osmium", "cat", testpath/"sample.osm.xml", "-o", "sample.osm.pbf"
    system bin/"imposm", "import", "-read", testpath/"sample.osm.pbf", "-mapping", testpath/"mapping.yml",
            "-cachedir", testpath/"cache"

    assert_predicate testpath/"cache/coords/LOG", :exist?
    assert_predicate testpath/"cache/nodes/LOG", :exist?
    assert_predicate testpath/"cache/relations/LOG", :exist?
    assert_predicate testpath/"cache/ways/LOG", :exist?
  end
end
