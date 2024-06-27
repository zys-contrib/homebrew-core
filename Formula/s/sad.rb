class Sad < Formula
  desc "CLI search and replace | Space Age seD"
  homepage "https://github.com/ms-jpq/sad"
  url "https://github.com/ms-jpq/sad/archive/refs/tags/v0.4.31.tar.gz"
  sha256 "c717e54798e21356340271e32e43de5b05ba064ae64edf639fede27b1ed15ceb"
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
