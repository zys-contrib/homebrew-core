class Ad < Formula
  desc "Adaptable text editor inspired by vi, kakoune, and acme"
  homepage "https://github.com/sminez/ad"
  url "https://github.com/sminez/ad/archive/refs/tags/0.2.0.tar.gz"
  sha256 "7bb4aba27b34e0eb0814bfa14c3b6d87a0c411e8ae12de2c62f76f23ab358a70"
  license "MIT"
  head "https://github.com/sminez/ad.git", branch: "develop"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # ad is a gui application
    assert_match "ad v#{version}", shell_output("#{bin}/ad --version").strip

    # test scripts
    (testpath/"test.txt").write <<~TXT
      Hello, World!
      Goodbye, World!
      hello, John!
      Hi, Alex!
    TXT

    (testpath/"hello.ad").write <<~AD
      ,
      x/[Hh]ello, (.*)!/
      p/$1\n/
    AD

    assert_match "World\nJohn\n", shell_output("#{bin}/ad -f #{testpath}/hello.ad #{testpath}/test.txt")
  end
end
