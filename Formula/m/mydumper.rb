class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https://launchpad.net/mydumper"
  url "https://github.com/mydumper/mydumper/archive/refs/tags/v0.16.11-2.tar.gz"
  sha256 "19ff7c07ef29bee1808e753465344209e256d8a7fcd10854cab25761520f342e"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(-\d+)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "66a0f313501191ba54a4492544977f97ba900d48663a67de7d1b8a18658994c7"
    sha256 cellar: :any,                 arm64_sonoma:  "1d6a9952b6393afdfd953e101ff31b62daa07918524c380ece363903200bb628"
    sha256 cellar: :any,                 arm64_ventura: "4eb1a9d08f32d12f7c6d42d9d99e23493dc8f0ee518a8654d03c659d1ddef89a"
    sha256 cellar: :any,                 sonoma:        "053026d6496a3eaafe417ea4f23ef200ec41adea4b5c9bc707a0348e84a067df"
    sha256 cellar: :any,                 ventura:       "fa05c413711ecb9ec087550df4be8f9f92aa88d5ead0d669f2b11824174c0b24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "879a45b58156dbd0fd8c972230cc4339d8d88c852c6fc07370505469e11f0bba"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build
  depends_on "glib"
  depends_on "mariadb-connector-c"
  depends_on "pcre"

  def install
    # Avoid installing config into /etc
    inreplace "CMakeLists.txt", "/etc", etc

    # Override location of mysql-client
    args = ["-DMYSQL_CONFIG_PREFER_PATH=#{Formula["mariadb-connector-c"].opt_bin}"]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"mydumper", "--help"
  end
end
