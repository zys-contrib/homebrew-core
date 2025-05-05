class Ittapi < Formula
  desc "Intel Instrumentation and Tracing Technology (ITT) and Just-In-Time (JIT) API"
  homepage "https://github.com/intel/ittapi"
  url "https://github.com/intel/ittapi/archive/refs/tags/v3.26.1.tar.gz"
  sha256 "e070b01293cd9ebaed8e5dd1dd0a662735637b1d144bbdcb6ba18fd90683accf"
  license "GPL-2.0-only"
  head "https://github.com/intel/ittapi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69ac3f71c63082ee64291bcbece9ade2f5f9f718c00185b751e9c1ed901656c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb23a4b5b8e76362acb9bf650509fea5392d343c54c37e46ad65d4ae3bdce950"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b51adc5f3f4c3458053a90e88c9fd073ea020744a14e332d8a4b24dec1cb318"
    sha256 cellar: :any_skip_relocation, sonoma:        "922f6a5ccd3c7346eb4a8531a3eaa9d6ee161e9fb85da5b2862655938a2a2aef"
    sha256 cellar: :any_skip_relocation, ventura:       "d1547116e8db91615040dc09341158ba029574ed842b8ebc7e086fa2e209a715"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf5f2d6a7263bd302fca6f0b394165213586fa87228596f8ce7ab8bf529a30a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e406047ef68498e5318abdf057acfab785a0facee8064f2e1c4d736d1154c9ad"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <ittnotify.h>

      __itt_domain* domain = __itt_domain_create("Example.Domain.Global");
      __itt_string_handle* handle_main = __itt_string_handle_create("main");

      int main()
      {
        __itt_task_begin(domain, __itt_null, __itt_null, handle_main);
        __itt_task_end(domain);
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-o", "test",
                    "-I#{include}",
                    "-L#{lib}", "-littnotify"
    system "./test"
  end
end
