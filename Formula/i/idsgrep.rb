class Idsgrep < Formula
  desc "Grep for Extended Ideographic Description Sequences"
  homepage "https://tsukurimashou.org/idsgrep.php.en"
  url "https://tsukurimashou.org/files/idsgrep-0.6.tar.gz"
  sha256 "2c07029bab12d9ceefddf447ce4213535b68d020b093a593190c2afa8a577c7c"
  license "GPL-3.0-only"

  livecheck do
    url :homepage
    regex(/href=.*idsgrep[._-]v?(\d+(?:\.\d+)+)\.t*/i)
  end

  depends_on "cmake" => :build
  depends_on "pcre"

  def install
    system "./configure", "--disable-silent-rules"
    system "make", "idsgrep"
    bin.install "idsgrep"
    man1.install "idsgrep.1"
    pkgshare.install "chise.eids"
  end

  test do
    expected = <<~EOS
      【䲤】⿰⻥<酒>⿰氵酉
      【酒】⿰氵酉
      【鿐】⿰魚<酒>⿰氵酉
      【𤄍】⿰<酒>⿰氵酉<留>⿱<CDP-8C69>⿰<CDP-88EE>;刀田
      【𦵩】⿱艹<酒>⿰氵酉
      【𫇓】⿳⿴𦥑<林>⿰木木冖<酒>⿰氵酉
      【𬜂】⿱⿴𦥑<林>⿰木木<酒>⿰氵酉
      【𭊼】⿱<酒>⿰氵酉<吒>⿰口<乇>⿱丿七
      【𭳒】⿰<酒>⿰氵酉<或>⿹戈<CDP-8BE2>⿱口一
    EOS
    assert_equal expected, shell_output("#{bin}/idsgrep -d '...酒' #{pkgshare}/chise.eids")
  end
end
