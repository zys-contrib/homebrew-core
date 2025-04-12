class Mydumper < Formula
  desc "MySQL logical backup tool"
  homepage "https://github.com/mydumper/mydumper"
  url "https://github.com/mydumper/mydumper/archive/refs/tags/v0.19.1-1.tar.gz"
  sha256 "5431a91befdb767f7620242da45673f699164f7590599b091f023f394802899c"
  license "GPL-3.0-or-later"
  head "https://github.com/mydumper/mydumper.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(-\d+)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a581ba06e8db7924ce8ff95264a3c73a371e267c755250abb7c17e70f3db5e5c"
    sha256 cellar: :any,                 arm64_sonoma:  "a7a0657680b2c11129fc7ba1b877c30bd3e3897e6de92a8289f0b46c318d9f9c"
    sha256 cellar: :any,                 arm64_ventura: "217bba665c89eaeefe7074b79cf9c9c6e642726c4990f59adb83c8d2c7afe1d4"
    sha256 cellar: :any,                 sonoma:        "db49c96b87a384708114d7e6262af351f0c7174c847882672bcebff5d6272ae3"
    sha256 cellar: :any,                 ventura:       "361fc367278b808a5affd2c77dce64455924916af94c6711b8b8910242872215"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d8d644f6becdefdb179bb52f497b213b50084065e9d127324e4e5bc66919e0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "687ad8a370611205beaf9ae22b157fc91a755b6d45c43097a80e3bd314e8528d"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build
  depends_on "glib"
  depends_on "mariadb-connector-c"
  depends_on "pcre2"

  on_macos do
    depends_on "openssl@3"
  end

  def install
    # Avoid installing config into /etc
    inreplace "CMakeLists.txt", "/etc", etc

    # Override location of mysql-client
    args = %W[
      -DMYSQL_CONFIG_PREFER_PATH=#{Formula["mariadb-connector-c"].opt_bin}
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"mydumper", "--help"
  end
end
