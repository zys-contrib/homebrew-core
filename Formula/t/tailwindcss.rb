class Tailwindcss < Formula
  desc "Utility-first CSS framework"
  homepage "https://tailwindcss.com"
  url "https://registry.npmjs.org/tailwindcss/-/tailwindcss-3.4.17.tgz"
  sha256 "c42aab85fa6442055980e2ce61b4328f64a25abef44907feb75bd90681331d2a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ef1e89aab19737e3c66462f57f0f61267e4ed4fdd9967df8f41b37ef66db56a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ef1e89aab19737e3c66462f57f0f61267e4ed4fdd9967df8f41b37ef66db56a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8a0a4bcb9fc57504bc217357eb758034d900b5b2040198f1d65153ccbeade325"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c15b605c267dd61402165f81113bcf07296d6941ef8b574c9b039154fff9651"
    sha256 cellar: :any_skip_relocation, ventura:       "879e7436c37cb8f65c418009e85216707354285730be1078795405d8ce9dac56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "646671381a5cbb0a2231f3a40021fbc2790311303f5c131d0d844ef892104ca2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"input.css").write("@tailwind base;")
    system bin/"tailwindcss", "-i", "input.css", "-o", "output.css"
    assert_path_exists testpath/"output.css"
  end
end
