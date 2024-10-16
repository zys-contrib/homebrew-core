class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https://github.com/DetachHead/basedpyright"
  url "https://registry.npmjs.org/basedpyright/-/basedpyright-1.19.0.tgz"
  sha256 "3671593db9fda88b70fd46f94bd1072c5fbe4a88198d51e98f9f01a93c1f22fe"
  license "MIT"
  head "https://github.com/detachhead/basedpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab91beba27f1adb1682999aab4a84fd3889e0b206301dd495de0cbafe7164f40"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab91beba27f1adb1682999aab4a84fd3889e0b206301dd495de0cbafe7164f40"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ab91beba27f1adb1682999aab4a84fd3889e0b206301dd495de0cbafe7164f40"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2fb05d6be64702455bcc263f17ad319eccf149d0d51421f9a0ed59b96cb5ee4"
    sha256 cellar: :any_skip_relocation, ventura:       "c2fb05d6be64702455bcc263f17ad319eccf149d0d51421f9a0ed59b96cb5ee4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab91beba27f1adb1682999aab4a84fd3889e0b206301dd495de0cbafe7164f40"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/pyright" => "basedpyright"
    bin.install_symlink libexec/"bin/pyright-langserver" => "basedpyright-langserver"
  end

  test do
    (testpath/"broken.py").write <<~EOS
      def wrong_types(a: int, b: int) -> str:
          return a + b
    EOS
    output = pipe_output("#{bin}/basedpyright broken.py 2>&1")
    assert_match "error: Type \"int\" is not assignable to return type \"str\"", output
  end
end
