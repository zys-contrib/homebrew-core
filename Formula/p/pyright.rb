class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.393.tgz"
  sha256 "8b18e165f045ce90bac365fc6730242c136add74a409dcd09c534efe2a5062a2"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "946f79382b843a3b46109600f6e9a4a88dc0480a4d8d09ef639aaf45e7c4fb5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "946f79382b843a3b46109600f6e9a4a88dc0480a4d8d09ef639aaf45e7c4fb5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "946f79382b843a3b46109600f6e9a4a88dc0480a4d8d09ef639aaf45e7c4fb5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2f5c66b287c8b65bbccc711da7c1f906e77bc1a6887c58d9b4b5476ec8f69d3"
    sha256 cellar: :any_skip_relocation, ventura:       "b2f5c66b287c8b65bbccc711da7c1f906e77bc1a6887c58d9b4b5476ec8f69d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "946f79382b843a3b46109600f6e9a4a88dc0480a4d8d09ef639aaf45e7c4fb5f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"broken.py").write <<~PYTHON
      def wrong_types(a: int, b: int) -> str:
          return a + b
    PYTHON
    output = pipe_output("#{bin}/pyright broken.py 2>&1")
    assert_match "error: Type \"int\" is not assignable to return type \"str\"", output
  end
end
