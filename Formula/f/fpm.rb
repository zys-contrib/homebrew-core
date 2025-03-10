class Fpm < Formula
  desc "Package manager and build system for Fortran"
  homepage "https://fpm.fortran-lang.org"
  url "https://github.com/fortran-lang/fpm/releases/download/v0.11.0/fpm-0.11.0.F90"
  sha256 "988a3317ee2448ee7207d0a29410f08a79c86bddac3314b2a175801a9cf58d27"
  license "MIT"

  depends_on "gcc" # for gfortran

  def install
    mkdir_p "build/bootstrap"
    system "gfortran", "-J", "build/bootstrap", "-o", "build/bootstrap/fpm", "fpm-#{version}.F90"
    bin.install "build/bootstrap/fpm"
  end

  test do
    system bin/"fpm", "new", "hello"
    assert_path_exists testpath/"hello"
  end
end
