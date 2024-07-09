class Soapyhackrf < Formula
  desc "SoapySDR HackRF module"
  homepage "https://github.com/pothosware/SoapyHackRF/wiki"
  url "https://github.com/pothosware/SoapyHackRF/archive/refs/tags/soapy-hackrf-0.3.4.tar.gz"
  sha256 "c7a1b8aee7af9d9e11e42aa436eae8508f19775cdc8bc52e565a5d7f2e2e43ed"
  license "MIT"

  depends_on "cmake" => :build
  depends_on "hackrf"
  depends_on "soapysdr"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{Formula["soapysdr"].bin}/SoapySDRUtil --check=hackrf")
    assert_match "Checking driver 'hackrf'... PRESENT", output
  end
end
