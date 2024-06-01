class Overtls < Formula
  desc "Simple proxy tunnel for bypassing the GFW"
  homepage "https://github.com/ShadowsocksR-Live/overtls"
  url "https://github.com/ShadowsocksR-Live/overtls/archive/refs/tags/v0.2.26.tar.gz"
  sha256 "3ffcdad396848559ac8f300c0d66d7f07713b1c200602943267ce18ced62fb34"
  license "MIT"
  head "https://github.com/ShadowsocksR-Live/overtls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7cd2a9afdcb66efc8f648a55c386a5046062a005b6c3d44fb8d9919bc05416e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "afec1fd01109c02c0f67dba131e96300a706f86e41ff4bc6449d9935234f3230"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9794f1b9dabe72bc3c07f5c422c65742613f7f712c739b569d2b64dddf05c1b5"
    sha256 cellar: :any_skip_relocation, sonoma:         "aed105d9affd0ce5a87103621bed4175511a66bef146b773efebfb4f7a281a41"
    sha256 cellar: :any_skip_relocation, ventura:        "3fd8ebc3fe63f3abd74f2f6ca46e5f61ff3a0dcaad48be0dd002d7449ec76dea"
    sha256 cellar: :any_skip_relocation, monterey:       "cd51aaf2a9a7fdb3b42bbee68591149a9147922eec7d991e258e105435730d47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d2e32720713046d2b5943032c7fc59ab2dc0c1d342dfb1c3c4d31074e5b6eaa"
  end

  depends_on "rust" => :build

  # version patch, upstream pr ref, https://github.com/ShadowsocksR-Live/overtls/pull/57
  patch do
    url "https://github.com/ShadowsocksR-Live/overtls/commit/33db5c7b33b0884f92b559f21b566de0751bf701.patch?full_index=1"
    sha256 "710c30129d490cccb65ebc9023dada0e0072b0e07b3e26686cd3f80ce14e4180"
  end

  def install
    system "cargo", "install", *std_cargo_args

    pkgshare.install "config.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/overtls -V")

    output = shell_output(bin/"overtls -r client -c #{pkgshare}/config.json 2>&1", 1)
    assert_match "Error: Io(Kind(TimedOut))", output
  end
end
