class Dssim < Formula
  desc "RGBA Structural Similarity Rust implementation"
  homepage "https://github.com/kornelski/dssim"
  url "https://github.com/kornelski/dssim/archive/refs/tags/3.3.4.tar.gz"
  sha256 "d95c1bbcf32220d6b3d348643345eab9295acb5ef44d8cbac5e3c9c1a2d40f96"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f6db8dac4f58b2a2ca49883851816c647e73be760cb139941241c46ddd78a70e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0dfd2b5a1c056ff3884f49982d7ac8d6960a7bf0e908cf0d5d926a84dd99eec4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2cd17c98c89c6d8e62ae6c95f4c642c99c57ffa52744347bfd15e75cae9abfb9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20c10ef5485635eab7e246dad306a17147d46e27939ea1780eed38b328497f01"
    sha256 cellar: :any_skip_relocation, sonoma:         "62bb524a94bf5c90463d244690a32591a7c3166bdddf8aa1a97f2fd0cd779e2f"
    sha256 cellar: :any_skip_relocation, ventura:        "7222cc33dad5c0f39a9496b1df83adfe2b83c8fa8eb112e6c7fd38f26e774893"
    sha256 cellar: :any_skip_relocation, monterey:       "8501f2023519307e078531d1d8bacd9cea878ef4b32e8a572536a3af54efc57d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1fca55387957980c34d82360e44f11d9f8e413bb40e7387f6d19fff1246de63"
  end

  depends_on "nasm" => :build
  depends_on "rust" => :build

  # revert `cc` crate to 1.2.7, upstream pr ref, https://github.com/kornelski/dssim/pull/172
  patch do
    url "https://github.com/kornelski/dssim/commit/2f1ce12942a3f54e3822f961f5a9687c17b6cf10.patch?full_index=1"
    sha256 "12386c9fb2859c6ea3713e30303e3ddcea63ee6a591aadd53deebd33163354bc"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"dssim", test_fixtures("test.png"), test_fixtures("test.png")
  end
end
