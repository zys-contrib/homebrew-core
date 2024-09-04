class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.379.tgz"
  sha256 "df7d4477fbc28a8ea85448b0feb6cb06672a3a49b59b5bdf9715e27775b1af14"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8f6497d6525e0bc579b33f73785d6a8a2d6b21826df68726476d88e04cf64cec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f6497d6525e0bc579b33f73785d6a8a2d6b21826df68726476d88e04cf64cec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f6497d6525e0bc579b33f73785d6a8a2d6b21826df68726476d88e04cf64cec"
    sha256 cellar: :any_skip_relocation, sonoma:         "bd0dc61b460890343115312639e6f2d6dfe1ec0f192baca8fc8685f4591b1108"
    sha256 cellar: :any_skip_relocation, ventura:        "bd0dc61b460890343115312639e6f2d6dfe1ec0f192baca8fc8685f4591b1108"
    sha256 cellar: :any_skip_relocation, monterey:       "bd0dc61b460890343115312639e6f2d6dfe1ec0f192baca8fc8685f4591b1108"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f6497d6525e0bc579b33f73785d6a8a2d6b21826df68726476d88e04cf64cec"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"broken.py").write <<~EOS
      def wrong_types(a: int, b: int) -> str:
          return a + b
    EOS
    output = pipe_output("#{bin}/pyright broken.py 2>&1")
    assert_match "error: Type \"int\" is not assignable to return type \"str\"", output
  end
end
