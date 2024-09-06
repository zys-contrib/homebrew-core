class Geni < Formula
  desc "Standalone database migration tool"
  homepage "https://github.com/emilpriver/geni"
  url "https://github.com/emilpriver/geni/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "e25c6a7c4aab967ecfce665c95bea07ae1ec3fb6c488f3f1887ee1dc47df2415"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9bb7d7f49d6a8110a22299460e21f36e15b0e3b2376127178719b07b1164ca3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd27c7620e31a6d5f83a4107b36dd90cd3c09f7e9610a712014cc584f2c3b6f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91bbdf44ca159e6410b5926c3e8603bd3b2d66f0dd81a6323bff405ccc992af2"
    sha256 cellar: :any_skip_relocation, sonoma:         "5215d8b5590fe2ae251be8f9e9ebd13211000d694d9d65850b120c97bad8d36c"
    sha256 cellar: :any_skip_relocation, ventura:        "7a7e5f4b83b51b7c54f47f235374b88f2b2217935db9af3daace5d7e94584ea4"
    sha256 cellar: :any_skip_relocation, monterey:       "36ab7cf0430727b0d742b6cefb38d1723d878b3170f117355725d6269e514348"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "142be6c20edda64a673a053744ba858b2edd92f229b529857bc6c143734ce0ab"
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
