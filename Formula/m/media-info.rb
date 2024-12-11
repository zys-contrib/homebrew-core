class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/24.12/MediaInfo_CLI_24.12_GNU_FromSource.tar.bz2"
  sha256 "5f7648080287d3e8f80dd8d606e285af81aa6a40dff1936fd528cbb74a0d97ff"
  license "BSD-2-Clause"
  head "https://github.com/MediaArea/MediaInfo.git", branch: "master"

  livecheck do
    url "https://mediaarea.net/en/MediaInfo/Download/Source"
    regex(/href=.*?mediainfo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2775e900c6ddb64cb56c71ec4b2e7811a00dc753466b1229ece62c3d07256f7c"
    sha256 cellar: :any,                 arm64_sonoma:  "0ef20c63f8aa02a405fb6ec5f059933353039dc981373d939612c4a43dfa7924"
    sha256 cellar: :any,                 arm64_ventura: "7e5773e817fbe92791f20aeb3053271d4b3aa5891306ca55a007865158176e68"
    sha256 cellar: :any,                 sonoma:        "49f9e8d86207e83f0ae1d8804c2193f05b0e1f6aab891d5f857e6a1420409bb7"
    sha256 cellar: :any,                 ventura:       "eeaeae9606fa1e0aa0456111b626d0d6f570d82570ecdc8157c417ecad49b3f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbb54082f50d7d5cd15864b6b2bf1bc0f275a5d6847570e09e36b2bc2fd207e7"
  end

  depends_on "pkgconf" => :build
  depends_on "libmediainfo"
  depends_on "libzen"

  uses_from_macos "zlib"

  def install
    cd "MediaInfo/Project/GNU/CLI" do
      system "./configure", *std_configure_args
      system "make", "install"
    end
  end

  test do
    output = shell_output("#{bin}/mediainfo #{test_fixtures("test.mp3")}")
    assert_match <<~EOS, output
      General
      Complete name                            : #{test_fixtures("test.mp3")}
      Format                                   : MPEG Audio
    EOS

    assert_match version.to_s, shell_output("#{bin}/mediainfo --Version")
  end
end
