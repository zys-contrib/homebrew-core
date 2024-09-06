class BcGh < Formula
  desc "Implementation of Unix dc and POSIX bc with GNU and BSD extensions"
  # The homepage is https://git.gavinhoward.com/gavin/bc but the Linux CI runner
  # has issues fetching the Gitea urls so we use the official GitHub mirror instead
  homepage "https://github.com/gavinhoward/bc"
  url "https://github.com/gavinhoward/bc/releases/download/7.0.1/bc-7.0.1.tar.xz"
  sha256 "d6da15d968611aa3fae78b7427bd35a44afb4bdcdd9fbe6259d27ea599032fa4"
  license "BSD-2-Clause"
  head "https://github.com/gavinhoward/bc.git", branch: "master"

  # TODO: keg_only :provided_by_macos (replaced GNU bc since Ventura)
  keg_only :shadowed_by_macos

  depends_on "pkg-config" => :build

  uses_from_macos "libedit"

  # TODO: conflicts_with "bc", because: "both install `bc` and `dc` binaries"

  def install
    # https://git.gavinhoward.com/gavin/bc#recommended-optimizations
    ENV.O3
    ENV.append "CFLAGS", "-flto"

    # NOTE: `--predefined-build-type` should be kept first to avoid overwriting later args
    system "./configure.sh", "--predefined-build-type=GNU",
                             "--disable-generated-tests",
                             "--disable-problematic-tests",
                             "--disable-nls",
                             "--enable-editline",
                             "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"bc", "--version"
    assert_match "2", pipe_output(bin/"bc", "1+1\n")
  end
end
