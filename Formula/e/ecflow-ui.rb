class EcflowUi < Formula
  desc "User interface for client/server workflow package"
  homepage "https://confluence.ecmwf.int/display/ECFLOW"
  url "https://confluence.ecmwf.int/download/attachments/8650755/ecFlow-5.13.2-Source.tar.gz"
  sha256 "948f848668455e68214acd8167a3ba581e4415e82524fc531e3e09ca257c3cd1"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECFLOW/Releases"
    regex(/href=.*?ecFlow[._-]v?(\d+(?:\.\d+)+)[._-]Source\.t/i)
  end

  bottle do
    sha256                               arm64_sonoma:   "ddca4250df99a1ce918364d4ec6f00508b6ebcc572a5f2f903b9079ac90322f3"
    sha256                               arm64_ventura:  "37636ad924f4ca0eafc45625e4a1bbf12cf6b10b2bcf5c2f65ec47abd13df22e"
    sha256                               arm64_monterey: "d73a00cdeeab08bf3afac4c24588a3b2a14556b3e7caf992fa41df8f2b824503"
    sha256                               sonoma:         "b94d38e8f38f156f1b467b9b519226fc6166821ddbb69500c617a94422f4e336"
    sha256                               ventura:        "fec08cce3db04bf38af7c799550d480f9de8f576c095ff9193cdc846d61e38cc"
    sha256                               monterey:       "c6604ac8a589701fa8e2c5c2031d79cdb234dd0209e6b2bd45658740b08698f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ce650dd2f5b055ca14b5e845e0171ed21783e13e769fa47af6f9adf3cc9a08f"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "openssl@3"
  depends_on "qt"

  uses_from_macos "libxcrypt"

  # requires C++17 compiler to build with Qt
  fails_with gcc: "5"

  def install
    args = %w[
      -DECBUILD_LOG_LEVEL=DEBUG
      -DENABLE_PYTHON=OFF
      -DENABLE_SERVER=OFF
      -DENABLE_SSL=1
      -DENABLE_TESTS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  # current tests assume the existence of ecflow_client, but we may not always supply
  # this in future versions, but for now it's the best test we can do to make sure things
  # are linked properly
  test do
    # check that the binary runs and that it can read its config and picks up the
    # correct version number from it
    binary_version_out = shell_output("#{bin}/ecflow_ui.x --version")
    assert_match @version.to_s, binary_version_out

    #  check that the startup script runs
    system "#{bin}/ecflow_ui", "-h"
    help_out = shell_output("#{bin}/ecflow_ui -h")
    assert_match "ecFlowUI", help_out
    assert_match "fontsize", help_out
    assert_match "start with the specified configuration directory", help_out
  end
end
