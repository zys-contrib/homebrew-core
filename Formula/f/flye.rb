class Flye < Formula
  include Language::Python::Virtualenv

  desc "De novo assembler for single molecule sequencing reads using repeat graphs"
  homepage "https://github.com/mikolmogorov/Flye"
  url "https://github.com/mikolmogorov/Flye/archive/refs/tags/2.9.6.tar.gz"
  sha256 "f05a3889b1c7aafed4cc0ed1adc1f19c22618c1c7b97ab5f80d388c8192bd32a"
  license all_of: ["BSD-3-Clause", "Apache-2.0", "BSD-2-Clause", "BSL-1.0", "MIT"]
  head "https://github.com/mikolmogorov/Flye.git", branch: "flye"

  depends_on "python@3.13"

  uses_from_macos "zlib"

  def install
    ENV.deparallelize
    virtualenv_install_with_resources
    pkgshare.install "flye/tests/data"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flye --version")
    cp_r pkgshare/"data/.", testpath
    system bin/"flye", "--pacbio-corr", "ecoli_500kb_reads_hifi.fastq.gz", "-o", testpath
    assert_path_exists "assembly.fasta"
  end
end
