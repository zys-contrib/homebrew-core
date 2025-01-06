class Bc < Formula
  desc "Arbitrary precision numeric processing language"
  homepage "https://www.gnu.org/software/bc/"
  url "https://ftp.gnu.org/gnu/bc/bc-1.08.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/bc/bc-1.08.1.tar.gz"
  sha256 "b71457ffeb210d7ea61825ff72b3e49dc8f2c1a04102bbe23591d783d1bfe996"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9fcd3785211342a0f70f9f4ae2c0a2386d9b97770112dd91e1b0154fe969b3da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f28c1c1070265e540f8e4ed3654543215ade6f873d57b2c88bf48bcf29294973"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8ac31554ea63cb26e2b3b09c00841b6c6e19d10132d79b274a3c3dc1cc75f478"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd63d528a58631598539406b115adcd020d01d4a8a355dd61a709ef73b2ca9d8"
    sha256 cellar: :any_skip_relocation, ventura:       "b2e61633d903d925fc56fae56d4c03d99e6fe3cef558c1017ad61e604bb64378"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f97276c2ec8b2883694ffa4f062c004ed07bf2966ca9847a2e8a3e365d6e8c8"
  end

  keg_only :provided_by_macos # before Ventura

  uses_from_macos "bison" => :build
  uses_from_macos "ed" => :build
  uses_from_macos "flex"
  uses_from_macos "libedit"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  conflicts_with "bc-gh", because: "both install `bc` and `dc` binaries"

  def install
    # prevent user BC_ENV_ARGS from interfering with or influencing the
    # bootstrap phase of the build, particularly
    # BC_ENV_ARGS="--mathlib=./my_custom_stuff.b"
    ENV.delete("BC_ENV_ARGS")

    system "./configure", "--disable-silent-rules",
                          "--infodir=#{info}",
                          "--mandir=#{man}",
                          "--with-libedit",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"bc", "--version"
    assert_match "2", pipe_output(bin/"bc", "1+1\n", 0)
  end
end
