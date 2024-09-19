class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https://launchpad.net/mydumper"
  url "https://github.com/mydumper/mydumper/archive/refs/tags/v0.16.7-3.tar.gz"
  sha256 "ef6a331f78cdb037837c885bef6b8b1e944fcb8c510d69881f4e6879dfa882d9"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(-\d+)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3198fdb8d5fee2aa1e7b2084d14dee3b1ab0926999c4bcf51ecacc1c7f49b192"
    sha256 cellar: :any,                 arm64_sonoma:  "97d1fbc30c4b5d1777bc3ad92ee7fd645ece0640cb0208f4cb5b2f57395ffd45"
    sha256 cellar: :any,                 arm64_ventura: "cf99682b2907461b0c7092fa18ceecce4048a4d7b6d989ab163b35492dbfd279"
    sha256 cellar: :any,                 sonoma:        "40c91cd1de31924e12a64f66c6e536dd8344694825e46c340d080ad8ef803f35"
    sha256 cellar: :any,                 ventura:       "18e17a180715f070c7edb38633d13727faf25f8d809b57ccf98958dacc2d9cb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdd54901d02f43303e89bd6e4b408db344466bdd273bfb2b4aaf8c2fc092d9c2"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "glib"
  depends_on "mysql-client"
  depends_on "pcre"
  depends_on "zlib"

  fails_with gcc: "5"

  def install
    # Avoid installing config into /etc
    inreplace "CMakeLists.txt", "/etc", etc

    # Override location of mysql-client
    args = std_cmake_args + %W[
      -DMYSQL_CONFIG_PREFER_PATH=#{Formula["mysql-client"].opt_bin}
      -DMYSQL_LIBRARIES=#{Formula["mysql-client"].opt_lib/shared_library("libmysqlclient")}
    ]
    # find_package(ZLIB) has trouble on Big Sur since physical libz.dylib
    # doesn't exist on the filesystem.  Instead provide details ourselves:
    if OS.mac?
      args << "-DCMAKE_DISABLE_FIND_PACKAGE_ZLIB=1"
      args << "-DZLIB_INCLUDE_DIRS=/usr/include"
      args << "-DZLIB_LIBRARIES=-lz"
    end

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system bin/"mydumper", "--help"
  end
end
