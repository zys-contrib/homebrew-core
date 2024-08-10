class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.41.1.tar.gz"
  sha256 "6b02ce49980636b067364717c51d5113153a4d40a02d6d8af1b5c7126ca02bc8"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e82319129ab04047cd816f14efbf18f8853ded83f40a0fb8011027bde049512f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86df94d28474aa5028f9105c0410a122c9398dc5a3c284cd2d1b530208e8f96a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "749b3fa8a1e2b1bf49193d8d38207dffc612359d60c960fe3bdaa12f49df3f56"
    sha256 cellar: :any_skip_relocation, sonoma:         "0f5ee08fafc98837db82f6f7e228bdc17ff28f374d82f1e57a6311b0e4d76d2d"
    sha256 cellar: :any_skip_relocation, ventura:        "c85f09adfbadfe6d5e06d6dbab7b6959096cbffeb35d241b7172a3f6264f4e32"
    sha256 cellar: :any_skip_relocation, monterey:       "eb3705b1794c75e3c1149721284c75ee1a98613cd8984125cc8188752846793c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "914c167ecdd0596884c07bf50621d0a62c14f33076405fe7e060cafd423a98c7"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "acl"
  end

  conflicts_with "nicotine-plus", because: "both install `nicotine` binaries"

  def install
    system "cargo", "install", "--features", "xattrs,acls", *std_cargo_args
    man1.install "httm.1"

    bin.install "scripts/ounce.bash" => "ounce"
    bin.install "scripts/bowie.bash" => "bowie"
    bin.install "scripts/nicotine.bash" => "nicotine"
    bin.install "scripts/equine.bash" => "equine"
  end

  test do
    touch testpath/"foo"
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end
