class Sylph < Formula
  desc "Ultrafast taxonomic profiling and genome querying for metagenomic samples"
  homepage "https://github.com/bluenote-1577/sylph"
  url "https://github.com/bluenote-1577/sylph/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "9dceb4e2302ece3ca225218dfb8367c88a88c98d1eb4e8eac82a202195584099"
  license "MIT"

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    pkgshare.install "test_files"
  end

  test do
    cp_r pkgshare/"test_files/.", testpath
    system bin/"sylph", "sketch", "o157_reads.fastq.gz"
    assert_path_exists "o157_reads.fastq.gz.sylsp"
  end
end
