class Glyph < Formula
  desc "Converts images/video to ASCII art"
  homepage "https://github.com/seatedro/glyph"
  url "https://github.com/seatedro/glyph/archive/refs/tags/v1.0.10.tar.gz"
  sha256 "1cfb17da971cc0daac9d0a7744dd1c05fd3382b2522d64e62cdfb28a8faf5d84"
  license "MIT"

  depends_on "pkgconf" => :build
  depends_on "zig" => :build
  depends_on "ffmpeg"

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    else Hardware.oldest_cpu
    end

    args = []
    args << "-Dcpu=#{cpu}" if build.bottle?
    system "zig", "build", *args, *std_zig_args
  end

  test do
    system bin/"glyph", "-i", test_fixtures("test.png"), "-o", "png.txt"
    assert_path_exists "png.txt"

    system bin/"glyph", "-i", test_fixtures("test.jpg"), "-o", "jpg.txt"
    assert_path_exists "jpg.txt"
  end
end
