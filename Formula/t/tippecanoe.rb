class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/felt/tippecanoe"
  url "https://github.com/felt/tippecanoe/archive/refs/tags/2.75.0.tar.gz"
  sha256 "4413cfc0d067af52f6aae8acf2aa8097b888f8e50b7d958b0f180c6bacce01f6"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d79c774dede63f27a53c80c5f81043766176f139f3240dd9e2420230b948b89d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "612ff40a3ca5aa0ab83e846d6c3af6262db4a079ec829ebe28e82fade75bc076"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c2999e8804bfdc87ae464905463274858a04d1ee8b11a199267d39614dc3077f"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c3e72d7d43498cd1d50af2eb1ff2d763aa56de7ead88cb337c0bee5f2ca4719"
    sha256 cellar: :any_skip_relocation, ventura:       "710cd193ea37722f680c83927fca70fa35e4434e515275e6b4c7310a1557b351"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f61b457bcccc68941074022f6244c7a5568d546ccd52b12afe2c2fafe83effcd"
  end

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.json").write <<~JSON
      {"type":"Feature","properties":{},"geometry":{"type":"Point","coordinates":[0,0]}}
    JSON
    safe_system bin/"tippecanoe", "-o", "test.mbtiles", "test.json"
    assert_predicate testpath/"test.mbtiles", :exist?, "tippecanoe generated no output!"
  end
end
