class Pv < Formula
  desc "Monitor data's progress through a pipe"
  homepage "https://www.ivarch.com/programs/pv.shtml"
  url "https://www.ivarch.com/programs/sources/pv-1.9.25.tar.gz"
  sha256 "162495aabb1cb842186cb224995e3d5f60a9f527a49ccbd8212383cc72b7c36c"
  license "Artistic-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?pv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2437040e5e0c4e04b9cae8afe7de0d2cde34c42c9097bd6eb231ffa811e8bdfa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df37d261b701946a58dd8260caaeacef84e725b4be580ffc5b2b622268268320"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "00792266783bbef4b6c77e3f05a2e1ed01c182530c3d87153ff203be4c0b1157"
    sha256 cellar: :any_skip_relocation, sonoma:        "269d144cbadb98063d9ecf3806d727709d696151d78a9efbde0080a874dbf4eb"
    sha256 cellar: :any_skip_relocation, ventura:       "15787a4a4af9495064f96ea43c866209f4433763b42e30343d32093c2ee43964"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b94bec3d0befce2e7f0f0e96edb8239e6b5e8ac8c66d8cab6400601b5e822a78"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}", "--disable-nls"
    system "make", "install"
  end

  test do
    progress = pipe_output("#{bin}/pv -ns 4 2>&1 >/dev/null", "beer")
    assert_equal "100", progress.strip

    assert_match version.to_s, shell_output("#{bin}/pv --version")
  end
end
