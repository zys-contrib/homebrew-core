class Ubi < Formula
  desc "Universal Binary Installer"
  homepage "https://github.com/houseabsolute/ubi"
  url "https://github.com/houseabsolute/ubi/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "6e240811fd6cbf2feaea41e821d71741903c2adb217e0fc8858f75c44dcf4d59"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/houseabsolute/ubi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d41fb93c5bacbde823658c82c29c15804194f536db6c00c1b918dcd3a8446a59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a020b89632a4018a8e050ead4583094b05cac0299b8e24b73deee388f6b36fa1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "26ce62c4b76c7981bbb80ecda0812ae4d3b1c65c74033444fc24e3f2a1eadd9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f63794b7e776b76494ce381139e492fefb4795cb35b2de8761bf762688e6e0a"
    sha256 cellar: :any_skip_relocation, ventura:       "76c9db5378cbde87f6b5e6354464750bbcd4188197ccdcdfa6889b9f494b05d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fb51c613149517442ea7dd3e170fc70600633738049373913c235f4defdbefd"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "xz" # required for lzma support

  uses_from_macos "bzip2"

  def install
    system "cargo", "install", *std_cargo_args(path: "ubi-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ubi --version")

    system bin/"ubi", "--project", "houseabsolute/precious"
    system testpath/"bin/precious", "--version"
  end
end
