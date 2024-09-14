class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/swsnr/mdcat"
  url "https://github.com/swsnr/mdcat/archive/refs/tags/mdcat-2.3.1.tar.gz"
  sha256 "5dbee35f8b582bb3a023133fc564103e49d16f10a62e7a07ddf29a06fa2d48f5"
  license "MPL-2.0"
  head "https://github.com/swsnr/mdcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c33dd68f2f6d8d3b6cd231066eb517ea198032a947e0e08aca77ca433f5641d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8d527e63b5d2637576d2e5d0ec7967ff28fba3326a6a2f1fe8398d5ca3f4a54"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc824e96ad0b6ecf285eeb8f0d2fc9cc005b19f17cb7e2f97f2eeabeaa3d3df0"
    sha256 cellar: :any_skip_relocation, sonoma:         "337024e0c95a589a176aaf54b2af76d8918f1138115071d676b5656a27718d6c"
    sha256 cellar: :any_skip_relocation, ventura:        "d5590516084cb1d62d9a751c8f1707137832f5016f2de5d430e3ece8b6258f69"
    sha256 cellar: :any_skip_relocation, monterey:       "54e7faca0303e2ef5cba4d84e76e24a6cfcb0c4652852252576d5c4533c17ee9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68db6d25634ac8a5b2c2bb51a9e7f6c0b72366868b49409eacfcf400ff308274"
  end

  depends_on "asciidoctor" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args

    # https://github.com/swsnr/mdcat?tab=readme-ov-file#packaging
    generate_completions_from_executable(bin/"mdcat", "--completions")
    system "asciidoctor", "-b", "manpage", "-a", "reproducible", "-o", "mdcat.1", "mdcat.1.adoc"
    man1.install Utils::Gzip.compress("mdcat.1")
  end

  test do
    (testpath/"test.md").write <<~EOS
      _lorem_ **ipsum** dolor **sit** _amet_
    EOS
    output = shell_output("#{bin}/mdcat --no-colour test.md")
    assert_match "lorem ipsum dolor sit amet", output
  end
end
