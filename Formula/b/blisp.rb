class Blisp < Formula
  desc "ISP tool & library for Bouffalo Labs RISC-V Microcontrollers and SoCs"
  homepage "https://github.com/pine64/blisp"
  url "https://github.com/pine64/blisp/archive/refs/tags/v0.0.4.tar.gz"
  sha256 "288a8165f7dce604657f79ee8eea895cc2fa4e4676de5df9853177defd77cf78"
  license "MIT"
  head "https://github.com/pine64/blisp.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "argtable3"
  depends_on "libserialport"

  def install
    args = %w[
      -DBLISP_USE_SYSTEM_LIBRARIES=ON
      -DBLISP_BUILD_CLI=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # workaround for fixing the header installations,
    # should be fixed with a new release, https://github.com/pine64/blisp/issues/67
    include.install Dir[lib/"blisp*.h"]
  end

  test do
    output = shell_output("#{bin}/blisp write -c bl70x --reset Pinecilv2_EN.bin 2>&1", 3)
    assert_match "Device not found", output

    assert_match version.to_s, shell_output("#{bin}/blisp --version")
  end
end
