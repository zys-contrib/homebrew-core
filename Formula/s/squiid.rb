class Squiid < Formula
  desc "Do advanced algebraic and RPN calculations"
  homepage "https://imaginaryinfinity.net/projects/squiid/"
  url "https://gitlab.com/ImaginaryInfinity/squiid-calculator/squiid/-/archive/1.2.0/squiid-1.2.0.tar.gz"
  sha256 "01f6142c986ce744ea7df86da17d43b593d56c8b843e6f502b0327ef43e3fcb8"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "315fbbb4a9553ca75652610cb44c2b9f39e87e6a803f9d4d24a64f618f32a682"
    sha256 cellar: :any,                 arm64_sonoma:  "8176fc788c278875b94cb0d8b85cb6523c4912d63ef781c84bebeb370de57087"
    sha256 cellar: :any,                 arm64_ventura: "71372763b97920cf07b0ea356fc6decdc89017814ca85b5273b0cab7b18d4469"
    sha256 cellar: :any,                 sonoma:        "1c29ed2240f777e20a2e0c15a9897e89e3c3b3236ad7829fdf172e8767be4cec"
    sha256 cellar: :any,                 ventura:       "4922877ef98b6d49f4f3de8dca3f5e5af4583d78c46b499c1ffc96f359e3f230"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "352d0187529dad2da4cfd5aa015592956e142969769772683a3b3ad4b87bd3cd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # squiid is a TUI app
    assert_match version.to_s, shell_output("#{bin}/squiid --version")
  end
end
