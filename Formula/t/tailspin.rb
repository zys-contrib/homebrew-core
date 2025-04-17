class Tailspin < Formula
  desc "Log file highlighter"
  homepage "https://github.com/bensadeh/tailspin"
  url "https://github.com/bensadeh/tailspin/archive/refs/tags/5.3.0.tar.gz"
  sha256 "1bd959e1fc4f095f0237170c9f88fb0b6b70b7d975a21c6f26ef3b484ad655f0"
  license "MIT"
  head "https://github.com/bensadeh/tailspin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8718e8706ef3ce73e5f41b77017456d99491552348218ceae526326c7478e046"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0d039e5b379737920ed7b2ebee73ad36a957f36344abb82966598e4b0c776df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "394db555cbbd6067a4c1fbb50ebcca9dc4a0fa5a7ea59985e2aa2eb8dccaad04"
    sha256 cellar: :any_skip_relocation, sonoma:        "fdc5e88f760f4787808e433554549a1e948cd8688a8bac9cc9144c8c408d5206"
    sha256 cellar: :any_skip_relocation, ventura:       "2f2550234cd77c76d5e046b408245e2f38fdf9d11d38746286bef88727825dd3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efc151614bb5a093b288bf28db8e1dfc92b0b1d2865ae0dfcf752543839123ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "040b222699a63e66c89a41f6df7ec16c2e561b4ad404729787194ddea0d0d282"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/tspin.bash" => "tspin"
    fish_completion.install "completions/tspin.fish"
    zsh_completion.install "completions/tspin.zsh" => "_tspin"
    man1.install "man/tspin.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tspin --version")

    (testpath/"test.log").write("test\n")
    system bin/"tspin", "test.log"
  end
end
