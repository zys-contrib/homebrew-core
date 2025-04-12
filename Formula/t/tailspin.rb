class Tailspin < Formula
  desc "Log file highlighter"
  homepage "https://github.com/bensadeh/tailspin"
  url "https://github.com/bensadeh/tailspin/archive/refs/tags/5.2.1.tar.gz"
  sha256 "c74823ad1f63017001db6f891f8d4c37b50cbbcad8be61634a67bb9ac7d74ad7"
  license "MIT"
  head "https://github.com/bensadeh/tailspin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8c2516dc0cf5929e0caea1101c37a7ac430444205ec9989373b7be5c2756487"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b642db9f8c65574f61dbb93b486f2241a2ae6e24f2ceae5dccb3b8245e0f529"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "087a99a2693a0e4b0b0dfa8a49c15700157efe58a3d5893d87ed3edb38197209"
    sha256 cellar: :any_skip_relocation, sonoma:        "636dc10348f30fa8c36f7cb55f4c323f282e3dcc04fbfa91fbbc6284a56f097e"
    sha256 cellar: :any_skip_relocation, ventura:       "f6e7e9ebd402904edae1e099356d6c9ab79ef7a7842aec03d86eb31ba9bf4789"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3952ed3673a9c6d9c3f9915fb1f6499d388a6c8a35b17e37d58532d840c3ffa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97b2d8260fb79ab1a4efc05265fa2fb002c32500bb546ac07b99188d876ccc9e"
  end

  depends_on "rust" => :build

  # Gracefully handle reading from file over stdin
  patch do
    url "https://github.com/bensadeh/tailspin/commit/36e9866c9ad9fa2e8bd4c966e1517c3c64a1282e.patch?full_index=1"
    sha256 "cd3ef1980c1380ee1b214ab025d1fe23b38ed298aade96eaa2c83a617116265d"
  end

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
