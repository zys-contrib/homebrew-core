class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/swsnr/mdcat"
  url "https://github.com/swsnr/mdcat/archive/refs/tags/mdcat-2.7.0.tar.gz"
  sha256 "e372a82291a139f95d77c12325a2f595f47f6d6b4c2de70e50ab2117e975734f"
  license "MPL-2.0"
  head "https://github.com/swsnr/mdcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a93a3d4bd92d4182b229f5923de3e23f75b0da674410a1f70b16038a414fb4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0486c54ca5265d8d6c56e3e674668ab37e0f57cdbac9013bd0e3c455097abc2b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b630f2c61910032a243d23be4695d554f8e337ef15297bc56485843aedea85c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f25d94399fe6ee142bc6153fddd97b03148704554ac6b450dcb228e05a22ba2"
    sha256 cellar: :any_skip_relocation, ventura:       "876b0529d2aa80d01d7a140a6fb85802c4a51c97ed6320bf8bad3d68d63dce08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3eea8ef2fe59b93fb583bd54776e546801167ffbaad9457522e07e18f58337ff"
  end

  depends_on "asciidoctor" => :build
  depends_on "rust" => :build

  uses_from_macos "curl"

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
    (testpath/"test.md").write <<~MARKDOWN
      _lorem_ **ipsum** dolor **sit** _amet_
    MARKDOWN
    output = shell_output("#{bin}/mdcat --no-colour test.md")
    assert_match "lorem ipsum dolor sit amet", output
  end
end
