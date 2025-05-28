class Ropebwt3 < Formula
  desc "BWT construction and search"
  homepage "https://github.com/lh3/ropebwt3"
  url "https://github.com/lh3/ropebwt3/archive/refs/tags/v3.9.tar.gz"
  sha256 "0c04879f97c92607017c00e0afc5a4e0428a8467573336300ebf3c1a6bcc4d75"
  license all_of: ["MIT", "Apache-2.0"]
  head "https://github.com/lh3/ropebwt3.git", branch: "master"

  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  def install
    args = []
    args << "LIBS=-L#{Formula["libomp"].opt_lib} -lomp -lpthread -lz -lm" if OS.mac?
    system "make", *args
    bin.install "ropebwt3"
  end

  test do
    (testpath/"test.txt").write <<~EOS
      TGAACTCTACACAACATATTTTGTCACCAAG
    EOS
    system bin/"ropebwt3", "build", "test.txt", "-Ldo", "idx.fmd"
    assert_path_exists "idx.fmd"
  end
end
