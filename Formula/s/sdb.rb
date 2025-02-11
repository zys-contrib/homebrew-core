class Sdb < Formula
  desc "Ondisk/memory hashtable based on CDB"
  homepage "https://github.com/radareorg/sdb"
  url "https://github.com/radareorg/sdb/archive/refs/tags/2.1.0.tar.gz"
  sha256 "877f1540f8890ee32ddfe5a03c3455d7d9bf344bc55a6ac42bdcc7ba241e8ab9"
  license "MIT"
  head "https://github.com/radareorg/sdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "58d13c328d1ed7b41fbb692d7bcd87e657ca2a2f7e0d583820436ac82a3c7079"
    sha256 cellar: :any,                 arm64_sonoma:  "0cd0d6f75a622d04d4b0e4a11bd88713bbcda7ab6bff745a0af845614e944baf"
    sha256 cellar: :any,                 arm64_ventura: "b447543663b247729c12bbcf5191d564b7dd7702cc66d019f3d03a7f9ab20503"
    sha256 cellar: :any,                 sonoma:        "70701ffdde52ba8e647a94e320246fcb758dbda7d6b91bb0b33543ccb96c7966"
    sha256 cellar: :any,                 ventura:       "1075c34dba2bd26539fde81339e210d0852c2b4c2589439ba35a4c4603d93f0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4f53aa55609f3bfd90b1bccf2503ce7ec281d8662992beef201f2b577a91b1c"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "vala" => :build
  depends_on "glib"

  conflicts_with "snobol4", because: "both install `sdb` binaries"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"sdb", testpath/"d", "hello=world"
    assert_equal "world", shell_output("#{bin}/sdb #{testpath}/d hello").strip
  end
end
