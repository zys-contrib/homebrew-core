class Dtsroll < Formula
  desc "CLI tool for bundling TypeScript declaration files"
  homepage "https://github.com/privatenumber/dtsroll"
  url "https://registry.npmjs.org/dtsroll/-/dtsroll-1.4.1.tgz"
  sha256 "26a3030a532a715ee29fcd8ec9b2cc20e92293d925d135c6c69ee114f39d71da"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4aaf6da89655bd3ef6efffaa43864993834a2c2906a8ce38d82b5520ccc7734a"
    sha256 cellar: :any,                 arm64_sonoma:  "4aaf6da89655bd3ef6efffaa43864993834a2c2906a8ce38d82b5520ccc7734a"
    sha256 cellar: :any,                 arm64_ventura: "4aaf6da89655bd3ef6efffaa43864993834a2c2906a8ce38d82b5520ccc7734a"
    sha256 cellar: :any,                 sonoma:        "8ba13591c84098ce42062f50731285ab777027da8081117304284c2d359e75c3"
    sha256 cellar: :any,                 ventura:       "8ba13591c84098ce42062f50731285ab777027da8081117304284c2d359e75c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aaa7c618b76c1a0781a581ac9cd7b929b64530eb32f6bcad45fb8f19a9f4139b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dtsroll --version")

    (testpath/"dts.d.ts").write "export type Foo = string;"

    assert_match "Entry points\n → dts.d.ts", shell_output("#{bin}/dtsroll dts.d.ts")
  end
end
