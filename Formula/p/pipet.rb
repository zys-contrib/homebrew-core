class Pipet < Formula
  desc "Swiss-army tool for web scraping, made for hackers"
  homepage "https://github.com/bjesus/pipet"
  url "https://github.com/bjesus/pipet/archive/refs/tags/0.2.2.tar.gz"
  sha256 "66e93172ad9e6706044bac6e815053a85312896588de1306102e65aa40db7569"
  license "MIT"
  head "https://github.com/bjesus/pipet.git", branch: "main"

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
