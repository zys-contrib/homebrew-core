class UserspaceRcu < Formula
  desc "Library for userspace RCU (read-copy-update)"
  homepage "https://liburcu.org"
  url "https://lttng.org/files/urcu/userspace-rcu-0.14.1.tar.bz2"
  sha256 "231acb13dc6ec023e836a0f0666f6aab47dc621ecb1d2cd9d9c22f922678abc0"
  license all_of: ["LGPL-2.1-or-later", "MIT"]

  livecheck do
    url "https://lttng.org/files/urcu/"
    regex(/href=.*?userspace-rcu[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7f97292c6b2ec6c304e4b1cd99e6c132602a38dc1e6e3e3f041790c40f873889"
    sha256 cellar: :any,                 arm64_ventura:  "416b50750d8377a585a4888f505e555bfdbe289ae4178991494d538ff2f1be5f"
    sha256 cellar: :any,                 arm64_monterey: "bdab779474bf1feb9209b8c3e722598a91c08b202d8ab2ce3e1331fc02e6e31f"
    sha256 cellar: :any,                 arm64_big_sur:  "af68e283caa6bd03ecddf38dcb02ce6f4e544395b0f080d0591887a791d1e569"
    sha256 cellar: :any,                 sonoma:         "941d8683de2bdee08e0e95f9e1ccc59ea6e2e019fb8528ec2255eb6e612377e3"
    sha256 cellar: :any,                 ventura:        "e604608f8a7f56421731aa3b91fbf33588156dfb3cef1e15c62d3e38f3e862c9"
    sha256 cellar: :any,                 monterey:       "c5ace1a972369e7a61c51d1e5f6a9aeb7a0cb5a7f9d28ade2ce1918d8c7e50c8"
    sha256 cellar: :any,                 big_sur:        "8771fdf50786cff24c9d40659100580e1aba5b0503c0204a07733dd46f5707a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e23f5d09163f5263dacfa83825ab64bc2a1fdd6fbd629d084a2d5722bb032257"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args.reject { |s| s["disable-debug"] }
    system "make", "install"
  end

  test do
    cp_r doc/"examples", testpath
    system "make", "CFLAGS=-pthread", "-C", "examples"
  end
end
