class Adapterremoval < Formula
  desc "Rapid adapter trimming, identification, and read merging"
  homepage "https://github.com/MikkelSchubert/adapterremoval"
  url "https://github.com/MikkelSchubert/adapterremoval/archive/refs/tags/v2.3.4.tar.gz"
  sha256 "a4433a45b73ead907aede22ed0c7ea6fbc080f6de6ed7bc00f52173dfb309aa1"
  license "GPL-3.0-or-later"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    ENV.deparallelize
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    examples = pkgshare/"examples"
    args = %W[
      --bzip2
      --file1 #{examples}/reads_1.fq
      --file2 #{examples}/reads_2.fq
      --basename #{testpath}/output
    ].join(" ")

    assert_match "Processed a total of 1,000 reads", shell_output("#{bin}/AdapterRemoval #{args} 2>&1")
  end
end
