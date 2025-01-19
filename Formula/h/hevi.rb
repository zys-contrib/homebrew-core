class Hevi < Formula
  desc "Hex viewer"
  homepage "https://github.com/Arnau478/hevi"
  url "https://github.com/Arnau478/hevi/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "d1c444301c65910b171541f1e3d1445cc3ff003dfc8218b976982f80bccd9ee0"
  license "GPL-3.0-or-later"

  depends_on "zig" => :build

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    else Hardware.oldest_cpu
    end

    args = %W[
      --prefix #{prefix}
      -Doptimize=ReleaseSafe
    ]

    args << "-Dcpu=#{cpu}" if build.bottle?
    system "zig", "build", *args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hevi --version 2>&1")
    assert_match "00000000", shell_output("#{bin}/hevi #{test_fixtures("test.pdf")}")
  end
end
