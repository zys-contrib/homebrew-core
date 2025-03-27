class Biosig < Formula
  desc "Tools for biomedical signal processing and data conversion"
  homepage "https://biosig.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/biosig/BioSig%20for%20C_C%2B%2B/src/biosig-3.9.0.src.tar.xz"
  sha256 "e5b353a1500e6f80150e1236919aef9679410a2337ee81ed056b3f306b25611e"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/(?:biosig|biosig4c[^-]*?)[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "117069306a551af329ca174824f8e68f8ecbfc9285ef33a0b9457137dafd1ca9"
    sha256 cellar: :any,                 arm64_sonoma:  "2afa576649a1ce599abd86cf16c92e8137e1fd5513401c0f91635c679f23732a"
    sha256 cellar: :any,                 arm64_ventura: "ec0026a9de7bed96c71de9d1e086134cb1f308582cd41f70457cc4fcd01b941b"
    sha256 cellar: :any,                 sonoma:        "3004a0bb2aa939134d7823a4db2355ea83f4fd9866870a6b9bbf1686e85a31e0"
    sha256 cellar: :any,                 ventura:       "3615427d4eaba6e8322770bdce3d29033bd8361a5613d682033e1477c4ce416c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e74145def1020e92731a83f67b2a805ecd74871cfe4936c425fa95a5de396cfe"
  end

  depends_on "gawk" => :build
  depends_on "libb64" => :build
  depends_on "dcmtk"
  depends_on "suite-sparse"

  def install
    ENV.append "CXX", "-std=gnu++17"

    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    ENV.deparallelize if OS.mac? && MacOS.version >= :sonoma
    system "make", "install"
  end

  test do
    assert_match "usage: save2gdf [OPTIONS] SOURCE DEST", shell_output("#{bin}/save2gdf -h").strip
    assert_match "mV\t4274\t0x10b2\t0.001\tV", shell_output("#{bin}/physicalunits mV").strip
    assert_match "biosig_fhir provides fhir binary template for biosignal data",
                 shell_output("#{bin}/biosig_fhir 2>&1").strip
  end
end
