class Sad < Formula
  desc "CLI search and replace | Space Age seD"
  homepage "https://github.com/ms-jpq/sad"
  url "https://github.com/ms-jpq/sad/archive/refs/tags/v0.4.30.tar.gz"
  sha256 "2f16ef0b904e27220491382d3de9e60ea1d5f62245869205c54a6d33f9e5dc34"
  license "MIT"
  head "https://github.com/ms-jpq/sad.git", branch: "senpai"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5092ae04fc8303d5a667caff1d98aebff6856133ed7dfe1c2d65d18a76aff30d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20a5298d599586f6489a7442aa8893e1135a4964b43f91e37f75fa8e1fe6186a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3754731da88ea672806c2696d875d7ce12eb20dcfea6198e7f1027d586fd6432"
    sha256 cellar: :any_skip_relocation, sonoma:         "c2446f7033467d72f8905b48205d5e52d7364286c05295e526b0a72674f91180"
    sha256 cellar: :any_skip_relocation, ventura:        "15d8349ac822ac48e59c458d76d93831c5666715e6247c7e605b804c761349fa"
    sha256 cellar: :any_skip_relocation, monterey:       "9f3fb6941202633ee051bb6be2d3b72fc289c491c07f0c058d8e732560b78110"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fb51b271c3627a7a5768687485514740546015647e84b9bf1da22694f3aff38"
  end

  depends_on "rust" => :build

  uses_from_macos "python" => :build

  # patch release version, upstream pr ref, https://github.com/ms-jpq/sad/pull/327
  patch do
    url "https://github.com/ms-jpq/sad/commit/d2a8bae6f3b64cc695020536e6f59b9ec7eb95e4.patch?full_index=1"
    sha256 "7e41c3739288928fcd718a0428c4e51d6c50818f07f5047bb9605cb269dd3af4"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    test_file = testpath/"test.txt"
    test_file.write "a,b,c,d,e\n1,2,3,4,5\n"
    system "find #{testpath} -name 'test.txt' | #{bin}/sad -k 'a' 'test' > /dev/null"
    assert_equal "test,b,c,d,e\n1,2,3,4,5\n", test_file.read

    assert_match "sad #{version}", shell_output("#{bin}/sad --version")
  end
end
