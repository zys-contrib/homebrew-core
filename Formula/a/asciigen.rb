class Asciigen < Formula
  desc "Converts images/video to ASCII art"
  homepage "https://github.com/seatedro/asciigen"
  url "https://github.com/seatedro/asciigen/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "2326d73376997f838bae25ebc7d1f6f84a7442db8f55ec841a7e11246b73c31f"
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

    args = %W[
      --prefix #{prefix}
    ]

    args << "-Dcpu=#{cpu}" if build.bottle?
    system "zig", "build", *args
  end

  test do
    system bin/"asciigen", "-i", test_fixtures("test.jpg"), "-o", "out.txt", "-c"
    assert_path_exists "out.txt"
  end
end
