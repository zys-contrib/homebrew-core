class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "44ae493c24f42f8994b4192ace99e63866c054e305d368bf77176108cbfa93fd"
  license "MIT"
  head "https://github.com/hatoo/oha.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "984dc4607535bb3a869d60fd1c34804ebfdd882b24dfd990eecafcd8679f4bf5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b23f4409e37e53965b0a82bfde684184f3080353c2e3aeac601e317069d953f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4132c0d27dc38f1745b0179b77498c1edaca6fb7d540346a23d0a08e1387a6c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "923cfd10cb1a3a398758aa6d2903df5ac91b473e0d49883db429eb759e38676c"
    sha256 cellar: :any_skip_relocation, ventura:       "eaed6763c85875e5e8b71a6f707364a5404aed32bec63b30a7914ec5d2c89719"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c077fcfef79627928278c2ac332303b34ffcdf13aa13e22d2d68ca992fe793c"
  end

  depends_on "cmake" => :build # for aws-lc-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  # revert `cc` crate to 1.2.7, upstream pr ref, https://github.com/hatoo/oha/pull/662
  patch do
    url "https://github.com/hatoo/oha/commit/e016c271326c201343cf17347dd5c5d6b0de1ab7.patch?full_index=1"
    sha256 "c3b9b1ef1486e0a9427b2623c8f6852c78fd7fd020383f36a5d2d62cb20b5970"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = "[200] 1 responses"
    assert_match output.to_s, shell_output("#{bin}/oha -n 1 -c 1 --no-tui https://www.google.com")

    assert_match version.to_s, shell_output("#{bin}/oha --version")
  end
end
