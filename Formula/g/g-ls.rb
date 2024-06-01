class GLs < Formula
  desc "Powerful and cross-platform ls"
  homepage "https://g.equationzhao.space"
  url "https://github.com/Equationzhao/g/archive/refs/tags/v0.28.2.tar.gz"
  sha256 "05df40665ea8c402c9d76b29269edb721758e9913bc03d173e7e84fa7a0a2ab6"
  license "MIT"
  head "https://github.com/Equationzhao/g.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "df5c1ddca9e3cfe67db33fcc23ee449fe7493efea755d096de8a2e44c8b0ce2f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b684688b57e3f961940e2d115c9db0ea7739af488733579f6b660a6044b84f0e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1be6c9a190423d129c8eddce1f1a01ca7d031dc9c2e340c84abae8d4f7885930"
    sha256 cellar: :any_skip_relocation, sonoma:         "1fc3139d750a0a70d99709cb447318dabd397e20563f3c76ed4f88037c1132ab"
    sha256 cellar: :any_skip_relocation, ventura:        "39adf004d5040353842990e2e4395c6007f0e99d4e34135dfef2b825f25b8dab"
    sha256 cellar: :any_skip_relocation, monterey:       "605b354ca9d93781dc53a648d90ffdf22c4b4d7d8f8e8810dfa9ba116bcf9bf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf4577e2c56f3c746c643e0f8372fe230458f1ca77ef5ac3c47f413a89c99496"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"g", ldflags: "-s -w")

    man1.install buildpath.glob("man/*.1.gz")
    zsh_completion.install "completions/zsh/_g"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/g -v")
    touch "test.txt"
    assert_match "test.txt", shell_output("#{bin}/g --no-config --hyperlink=never --color=never --no-icon .")
  end
end
