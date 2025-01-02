class Zigup < Formula
  desc "Download and manage zig compilers"
  homepage "https://github.com/marler8997/zigup"
  url "https://github.com/marler8997/zigup/archive/refs/tags/v2025_01_02.tar.gz"
  sha256 "0b92de2a3afcecbf086102733215640189d744c4a17064b7492059ac198dd7f6"
  license "MIT-0"

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
    system bin/"zigup", "fetch-index"
    assert_match "install directory", shell_output("#{bin}/zigup list 2>&1")
  end
end
