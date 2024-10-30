class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https://github.com/DetachHead/basedpyright"
  url "https://registry.npmjs.org/basedpyright/-/basedpyright-1.20.0.tgz"
  sha256 "372a861dc1663e25619c23a487aa716197c3b6bda774fbcf27850a64f69febef"
  license "MIT"
  head "https://github.com/detachhead/basedpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13eaf7187296d03b12699508d6eeb9495b9f4592b3bc8d8a811425855c75d98c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13eaf7187296d03b12699508d6eeb9495b9f4592b3bc8d8a811425855c75d98c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "13eaf7187296d03b12699508d6eeb9495b9f4592b3bc8d8a811425855c75d98c"
    sha256 cellar: :any_skip_relocation, sonoma:        "b27f54047f51eeaef5c1b2fe32ef47ee20f6cc3c9edab536886cbb9f37fd33d2"
    sha256 cellar: :any_skip_relocation, ventura:       "b27f54047f51eeaef5c1b2fe32ef47ee20f6cc3c9edab536886cbb9f37fd33d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13eaf7187296d03b12699508d6eeb9495b9f4592b3bc8d8a811425855c75d98c"
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
