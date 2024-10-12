class Pipet < Formula
  desc "Swiss-army tool for web scraping, made for hackers"
  homepage "https://github.com/bjesus/pipet"
  url "https://github.com/bjesus/pipet/archive/refs/tags/0.3.0.tar.gz"
  sha256 "9fb35bcc4be8b7655a4075c3b2bf7b0368ae7bb97e9e6dbbcf00422c8e18cc6b"
  license "MIT"
  head "https://github.com/bjesus/pipet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d469becb32ebbedcc44206826e2158e73ff5396b410c3ef45e75ff34deeb3e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d469becb32ebbedcc44206826e2158e73ff5396b410c3ef45e75ff34deeb3e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d469becb32ebbedcc44206826e2158e73ff5396b410c3ef45e75ff34deeb3e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "a58e3beebefc4356d5f14cd1f7800ae71c39a4baa73cdfe23b96339a7b9d0426"
    sha256 cellar: :any_skip_relocation, ventura:       "a58e3beebefc4356d5f14cd1f7800ae71c39a4baa73cdfe23b96339a7b9d0426"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fa415e76fd5af27cab8de96ee16bc41e7637d8536ae22f7f3a3cba324a4d628"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/pipet"
  end

  test do
    (testpath/"example.pipet").write <<~EOS
      curl https://example.com
      head > title
    EOS

    assert_match "Example Domain", shell_output("#{bin}/pipet example.pipet")
  end
end
