class Krep < Formula
  desc "High-Performance String Search Utility"
  homepage "https://github.com/davidesantangelo/krep"
  url "https://github.com/davidesantangelo/krep/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "815834208b2abd15386374b7d9258f9b37fec40cc3419e2be994d1f7965ef661"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "754038d5fbe381bd8885855a860acb6ec15aa3d2e55627be014253a466a816e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50f7efef1fbdf43e15d0157ca11fa5346092f4ab0b08f34d4bfd47767561415e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "02485f8423dadaa81f45654461153ce352d02d8af1ed4ec8e4d829afe1c3cf9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "65ec3ea71eb41d8d8c464a91aeb771617058c0781cf81220f458331db4400594"
    sha256 cellar: :any_skip_relocation, ventura:       "67d018d0f60996c44a12a2198d83f7451c3658c5a8e75b73deb85699136ad57d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0db0ab4eb942bb8e77bfc9c59e144811625360b99b4828a211465d64736c2055"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b41852e52bc1a35d1250b1d10b4568ca6f0b2bd8e027e6a8e11ff0432ea49e93"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/krep -v")

    text_file = testpath/"file.txt"
    text_file.write "This should result in one match"

    output = shell_output("#{bin}/krep -c 'match' #{text_file}").strip
    assert_match "1", output
  end
end
