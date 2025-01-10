class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "164090bddb729adf22172ab7731707507b6dd60f8f3c642a59c444778c28ee18"
  license "MIT"
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f650ba5593fe3c2f757f2f6b05f4ae64edb9ca0cad845997a0965eebac7fc03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9db6c21f62b3a3153f626a3bf436b997ee38e92ab53fd5262635e4e822141575"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "38a5fc4ce73e7b2eef5b12279f016e65b07e0ad750aab5b72b9c9b4b96caf053"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c64b64add77d915950cf36ec1b9a26dfbec40810c4abb3a5a3f0b3d96e9417b"
    sha256 cellar: :any_skip_relocation, ventura:       "53dde255a5ad6416f94311c9d3ea874adf5d4b29c32a2f5637ea3deb21cebc4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92f3661a4f72dec5cef80791d510f5e55f21fe26557db377ff651df11dc6fac5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match "usage-cli", shell_output(bin/"usage --version").chomp
    assert_equal "--foo", shell_output(bin/"usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end
