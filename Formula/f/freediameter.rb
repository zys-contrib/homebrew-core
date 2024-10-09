class Freediameter < Formula
  desc "Open source Diameter (Authentication) protocol implementation"
  homepage "https://github.com/freeDiameter/freeDiameter"
  license "BSD-3-Clause"
  head "https://github.com/freeDiameter/freeDiameter.git", branch: "master"

  stable do
    url "https://github.com/freeDiameter/freeDiameter/archive/refs/tags/1.5.0.tar.gz"
    sha256 "cc4ceafd9d0d4a6a5e3aa02bf557906fe755df9ec14d16c4fcd5dab6930296aa"

    # Backport support for `libidn2`. Remove in the next release.
    patch do
      url "https://github.com/freeDiameter/freeDiameter/commit/da679d27c546e11f6e41ad8882699f726e58a9f7.patch?full_index=1"
      sha256 "123fe68ede4713b8e78efa49bfe9db592291cc3c821bbdc58f930a1f291423b1"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256                               arm64_sequoia:  "1f127dcfd63b0987b992e01240782318353def96d22dc980374a0154d4713f7d"
    sha256                               arm64_sonoma:   "7ed309fba8336ee1a69062381b099795d76033ede4827816266ad8f54811a8f3"
    sha256                               arm64_ventura:  "1ef1f7466e21afed5e41acc5a485b938801df184aa4205f4407b52ffbddde7c4"
    sha256                               arm64_monterey: "e659a5cb363d17a28fa68565c041bbc3d5497afd90e401f2c555addf9723a9b6"
    sha256                               sonoma:         "330234376a5de64ff3788110ecc3d007a9b5b86eea85862cabb8f8977c9ad293"
    sha256                               ventura:        "e7b45438bbe4b3599841717f3cf60fc6782d9cb6dc8b32720f5cb99053f5f1ca"
    sha256                               monterey:       "c193f037e6d228e8023076c299050d76ee7de40e766ecb101068098bd5ef80cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ec1217addb5078d017d58fac23eed0a6fb27dfb70e08637609345fe6f8ea2df"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "libidn2"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DDEFAULT_CONF_PATH=#{etc}",
                    "-DDISABLE_SCTP=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    doc.install Dir["doc/*"]
    pkgshare.install "contrib"
  end

  def post_install
    return if File.exist?(etc/"freeDiameter.conf")

    cp doc/"freediameter.conf.sample", etc/"freeDiameter.conf"
  end

  def caveats
    <<~EOS
      To configure freeDiameter, edit #{etc}/freeDiameter.conf to taste.

      Sample configuration files can be found in #{doc}.

      For more information about freeDiameter configuration options, read:
        http://www.freediameter.net/trac/wiki/Configuration

      Other potentially useful files can be found in #{opt_pkgshare}/contrib.
    EOS
  end

  service do
    run opt_bin/"freeDiameterd"
    keep_alive true
    require_root true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/freeDiameterd --version")
  end
end
