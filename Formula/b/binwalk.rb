class Binwalk < Formula
  desc "Searches a binary image for embedded files and executable code"
  homepage "https://github.com/ReFirmLabs/binwalk"
  url "https://github.com/ReFirmLabs/binwalk/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "06f595719417b70a592580258ed980237892eadc198e02363201abe6ca59e49a"
  license "MIT"
  head "https://github.com/ReFirmLabs/binwalk.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "506a9dc4f71c32dbbc776b51b0c14f89b328fda5bb1ca353378cd2e84433c348"
    sha256 cellar: :any,                 arm64_sonoma:  "a4bffc734e4b661c4f9112d5a4e461eea14d54d2e5044c51cfdb3ce76958cd32"
    sha256 cellar: :any,                 arm64_ventura: "7a12626b14bc214cdd517510500213e56c68638ef6aca7eff35f140b0277e570"
    sha256 cellar: :any,                 sonoma:        "6026add10f56bdecc3f9889e8a62df72bf51532a747cae9c0a7c5efe564bff5d"
    sha256 cellar: :any,                 ventura:       "8ab2298e03a976787dfaac014c668bd6732b298f80fe231191ebfa2fb4bcd58d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb092294fbef182e109d711d98ac69441ecc3cf9ed8d55a6e9f6a605e9eaad82"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "p7zip"
  depends_on "xz"

  on_linux do
    depends_on "fontconfig"
    depends_on "freetype"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch "binwalk.test"
    system bin/"binwalk", "binwalk.test"
  end
end
