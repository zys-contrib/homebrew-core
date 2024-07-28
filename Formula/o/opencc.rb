class Opencc < Formula
  desc "Simplified-traditional Chinese conversion tool"
  homepage "https://github.com/BYVoid/OpenCC"
  url "https://github.com/BYVoid/OpenCC/archive/refs/tags/ver.1.1.8.tar.gz"
  sha256 "51693032e702ccc60765b735327d3596df731bf6f426b8ab3580c677905ad7ea"
  license "Apache-2.0"

  bottle do
    sha256 arm64_sonoma:   "aa74cb1dcfdc0f882acbca3f671ccbcc805ddfa76ef1d579a7cb3a6dbb441724"
    sha256 arm64_ventura:  "9a8da24b7dd2febef42257df7e2f072d8ff759e9da1fca7d4ef38767707ccced"
    sha256 arm64_monterey: "c9b669e17ba4df32320297a8cee6d7738b03d2a3e1d69e5c22e755e671bcd0d4"
    sha256 sonoma:         "a40362d0f783eeafe97e718956236c7de236ed12fdc0b9f0e8de09dd3f0e7931"
    sha256 ventura:        "41dca10c1d8cf7bcb829364a9b3d9f03e0bb2557e15f67a6363ce2d795ff9059"
    sha256 monterey:       "e7e58e4c8a225084a112537ffcc7ecdb08052d13946dea3023c2fa2431f44869"
    sha256 x86_64_linux:   "ced3e475ceac81b5af845ce43e15fc085afca1db3b74cfdff68628d015a4e808"
  end

  depends_on "cmake" => :build
  uses_from_macos "python" => :build

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DPYTHON_EXECUTABLE=#{which("python3")}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    input = "中国鼠标软件打印机"
    output = pipe_output("#{bin}/opencc", input)
    output = output.force_encoding("UTF-8") if output.respond_to?(:force_encoding)
    assert_match "中國鼠標軟件打印機", output
  end
end
