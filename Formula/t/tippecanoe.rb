class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/felt/tippecanoe"
  url "https://github.com/felt/tippecanoe/archive/refs/tags/2.63.0.tar.gz"
  sha256 "653fe695550f0d8ac21dcc96865cba3f9c2d162c8ebe9b50a11053320f846332"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67f21238fc3a8d988e641d72247040b2c9e8528a45b16059b35d0501e6778919"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac7fea14ca847cfab73d0fec0751a19b13d665f30ce3fc057a1c1ed1e507cbbb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "75a8118f6941579ac13aa90dc1694012643011d6479d33c21dc803fe2b9f35a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "aab506afdfac678669b4afed23f847754b9e1732c21a5fc1e2b75d4c88898b0d"
    sha256 cellar: :any_skip_relocation, ventura:       "db875104c477fbb377e9ed088e574f5ed01f7fdc46eb6ce3fd0de73a2b55a084"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e642bab20f9a68b18b35acb7436b3d2e64a3091d71a48f7998b40af06c1a81ad"
  end

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.json").write <<~EOS
      {"type":"Feature","properties":{},"geometry":{"type":"Point","coordinates":[0,0]}}
    EOS
    safe_system bin/"tippecanoe", "-o", "test.mbtiles", "test.json"
    assert_predicate testpath/"test.mbtiles", :exist?, "tippecanoe generated no output!"
  end
end
