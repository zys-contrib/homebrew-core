class JsonFortran < Formula
  desc "Fortran 2008 JSON API"
  homepage "https://github.com/jacobwilliams/json-fortran"
  url "https://github.com/jacobwilliams/json-fortran/archive/refs/tags/9.0.1.tar.gz"
  sha256 "1a6fd50220527d27ba0a46113b09b4f5cb5a48a0d090ddc36d3fddf6cf412e56"
  license "BSD-3-Clause"
  head "https://github.com/jacobwilliams/json-fortran.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "919866643beb37c81cd1b8fd929c0fd3b7da1b78e1841a5231e3d40d155f1b89"
    sha256 cellar: :any,                 arm64_ventura:  "530890acd122e2b3f92adc7b2965653c2f6f7730ffe505b35823d147d3aa5859"
    sha256 cellar: :any,                 arm64_monterey: "b2eab3d6fa29973f5be90c344de27e7942fbb11ae8cedc68acc429c11822ec1c"
    sha256 cellar: :any,                 sonoma:         "addb0dc342a875d23ea5974b142af739a8f0e71b1c07335fcb1440fe12e7e095"
    sha256 cellar: :any,                 ventura:        "eca7920ce7135fe8b3f99edef6cbb1256b56c56e9fe134da97e86b5f3faf6186"
    sha256 cellar: :any,                 monterey:       "667341f629741a5e1cee3676c1ac61b2ec22b12a0e5dc46af38e9ca2547b5bed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe69a87bfb811d13a1571c25d58902b269bc94fd9ef6cdf1bdba8d8a10661e6f"
  end

  depends_on "cmake" => :build
  depends_on "ford" => :build
  depends_on "gcc" # for gfortran

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DUSE_GNU_INSTALL_CONVENTION:BOOL=TRUE",
                            "-DENABLE_UNICODE:BOOL=TRUE"
      system "make", "install"
    end
  end

  test do
    (testpath/"json_test.f90").write <<~EOS
      program example
      use json_module, RK => json_RK
      use iso_fortran_env, only: stdout => output_unit
      implicit none
      type(json_core) :: json
      type(json_value),pointer :: p, inp
      call json%initialize()
      call json%create_object(p,'')
      call json%create_object(inp,'inputs')
      call json%add(p, inp)
      call json%add(inp, 't0', 0.1_RK)
      call json%print(p,stdout)
      call json%destroy(p)
      if (json%failed()) error stop 'error'
      end program example
    EOS
    system "gfortran", "-o", "test", "json_test.f90", "-I#{include}",
                       "-L#{lib}", "-ljsonfortran"
    system "./test"
  end
end
