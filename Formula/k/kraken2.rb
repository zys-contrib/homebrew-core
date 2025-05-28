class Kraken2 < Formula
  desc "Taxonomic sequence classification system"
  homepage "https://github.com/DerrickWood/kraken2"
  url "https://github.com/DerrickWood/kraken2/archive/refs/tags/v2.1.5.tar.gz"
  sha256 "6feb9b1e0840a574598b84a3134a25622e5528ac6d0f4c756cdab629275d8f42"
  license "MIT"
  head "https://github.com/DerrickWood/kraken2.git", branch: "master"

  depends_on "python@3.13"
  depends_on "wget"

  uses_from_macos "perl"
  uses_from_macos "rsync"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  def install
    system "./install_kraken2.sh", libexec
    %w[k2 kraken2 kraken2-build kraken2-inspect].each do |f|
      bin.install_symlink libexec/f
    end
    pkgshare.install "data"
  end

  test do
    cp pkgshare/"data/Lambda.fa", testpath
    system bin/"kraken2-build", "--add-to-library", "Lambda.fa", "--db", "testdb"
    assert_path_exists "testdb"
  end
end
