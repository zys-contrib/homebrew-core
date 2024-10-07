class Eiffelstudio < Formula
  desc "Development environment for the Eiffel language"
  homepage "https://www.eiffel.com"
  url "https://ftp.eiffel.com/pub/download/23.09/pp/PorterPackage_std_23.09_107341.tar"
  version "23.09.107341"
  sha256 "f92dad3226b81e695ba6deb752d7b8e84351f1dcab20e18492cc56a2b7d8d4b1"
  license "GPL-2.0-only"

  livecheck do
    url "https://ftp.eiffel.com/pub/download/latest/pp/"
    regex(/href=.*?PorterPackage[._-]std[._-]v?(\d+(?:[._-]\d+)+).t/i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match[0].tr("_-", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "eb80572a9f45330718c9d37480bf5dd883654e1fef524447d828558d3fa86223"
    sha256 cellar: :any,                 arm64_ventura:  "13f283babf97160d03bd4793575262df0d96abccbab80a0e23749c43c72b2000"
    sha256 cellar: :any,                 arm64_monterey: "b38d768b91d114b8e1fcc2f010043ded8d4fafaec9858b1523044d33d3c78331"
    sha256 cellar: :any,                 sonoma:         "c431ca8133ea66b0ca7d454c9df091cbbfe49919452eff177bcb60ef2704de05"
    sha256 cellar: :any,                 ventura:        "b9e26ab5cd7c6743642b95b88062306a61e1347daa3cb78d986f8b66d770765b"
    sha256 cellar: :any,                 monterey:       "94244ccd7e1fcb3c01386840912cc5a1e0b57e54431493b40a57b2258e05963d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e8570d391bf49d1208347ae385debef2ef5b3156a338417ecfa8b05610ee4ad"
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "libx11"
  depends_on "pango"

  uses_from_macos "pax" => :build

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  def install
    platform = "#{OS.mac? ? "macosx" : OS.kernel_name.downcase}-x86-64"

    # Apply workarounds
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500
    system "tar", "xf", "c.tar.bz2"
    inreplace "C/CONFIGS/#{platform}" do |s|
      if OS.mac?
        # Fix flat namespace usage in C shared library.
        s.gsub! "-flat_namespace -undefined suppress", "-undefined dynamic_lookup"
      else
        # Use ENV.cc to link shared objects instead of directly invoking ld.
        # Reported upstream: https://support.eiffel.com/report_detail/19873.
        s.gsub! "sharedlink='ld'", "sharedlink='#{ENV.cc}'"
        s.gsub! "ldflags=\"-m elf_x86_64\"", "ldflags=''"
      end
    end
    system "tar", "cjf", "c.tar.bz2", "C"

    system "./compile_exes", platform
    system "./make_images", platform
    prefix.install (buildpath/"Eiffel_#{version.to_s[/^(\d+\.\d+)/, 1]}").children

    eiffel_env = { ISE_EIFFEL: prefix, ISE_PLATFORM: platform }
    {
      studio:       %w[ec ecb estudio finish_freezing],
      tools:        %w[compile_all iron syntax_updater],
      vision2_demo: %w[vision2_demo],
    }.each do |subdir, targets|
      targets.each do |target|
        (bin/target).write_env_script prefix/subdir.to_s/"spec"/platform/"bin"/target, eiffel_env
      end
    end
  end

  test do
    # More extensive testing requires the full test suite
    # which is not part of this package.
    system bin/"ec", "-version"
  end
end
