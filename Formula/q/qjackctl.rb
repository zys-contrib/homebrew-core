class Qjackctl < Formula
  desc "Simple Qt application to control the JACK sound server daemon"
  homepage "https://qjackctl.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/qjackctl/qjackctl/1.0.4/qjackctl-1.0.4.tar.gz"
  sha256 "e3eb6f989d947dcd97b4fe774294347106a0a6829c0480a965393ebca97514ae"
  license "GPL-2.0-or-later"
  head "https://git.code.sf.net/p/qjackctl/code.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/qjackctl[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:  "3ada6e00a333d32a28f1af22085e8d79971aec196b65f21d6c91bca5d0704734"
    sha256 arm64_ventura: "28a403e1d6b7b3b7981726dc7a2dce3e17e9ba8e3d68489766fcb6df888efbb9"
    sha256 sonoma:        "0499da41a736c4f0b131018cbd093451cae348268cfdfb30587c5ac65c980bf6"
    sha256 ventura:       "89c2f994e56f8139a761ebd4700671df769407baaf7e4be9d450d1e02a414166"
    sha256 x86_64_linux:  "277322f52ed5a1f29bed583f5320621409c013b5339d84df5ef1a3cf376ebbf5"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "jack"
  depends_on "qt"

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    args = %w[
      -DCONFIG_DBUS=OFF
      -DCONFIG_PORTAUDIO=OFF
      -DCONFIG_XUNIQUE=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    if OS.mac?
      prefix.install bin/"qjackctl.app"
      bin.install_symlink prefix/"qjackctl.app/Contents/MacOS/qjackctl"
    end
  end

  test do
    # Detected locale "C" with character encoding "US-ASCII", which is not UTF-8.
    ENV["LC_ALL"] = "en_US.UTF-8"

    # Set QT_QPA_PLATFORM to minimal to avoid error "qt.qpa.xcb: could not connect to display"
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match version.to_s, shell_output("#{bin}/qjackctl --version 2>&1", 1)
  end
end
