class Geni < Formula
  desc "Standalone database migration tool"
  homepage "https://github.com/emilpriver/geni"
  url "https://github.com/emilpriver/geni/archive/refs/tags/v1.0.14.tar.gz"
  sha256 "a27599bb9c6779d5be5269fabc68e232f6afc2c7f78f3dd6d2f342ff309421b0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7978c2a09a02fa3014376e699f112e570ac47776b2d6aec7914df969e163be8b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8118eafe9e8962701aff9d16317fcb2b2d47b3631d342c9524d7f37701a2b6b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19c9ce8b4bc27a62fd23c89a434d59fc57e5568e59be7606b0884d90d97abcae"
    sha256 cellar: :any_skip_relocation, sonoma:         "38196584de6f10ebc656c0d29964eb241392072c20ce1321ef165c11e9f981aa"
    sha256 cellar: :any_skip_relocation, ventura:        "474b45c0ee476c23e3cfebc96ae66b009a4adffb657bb32a4f43831b928ae367"
    sha256 cellar: :any_skip_relocation, monterey:       "739bc8423bb18b2d59230def2315f48ef803adc8ff0628a339d3fc1636b32398"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37e62346a16b3e96e3a3f8a80d4db6f528662a27fad83238a070613bc2f45465"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["DATABASE_URL"] = "sqlite3://test.sqlite"
    system bin/"geni", "create"
    assert_predicate testpath/"test.sqlite", :exist?, "failed to create test.sqlite"
    assert_match version.to_s, shell_output("#{bin}/geni --version")
  end
end
