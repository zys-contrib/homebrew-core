class Tailwindcss < Formula
  desc "Utility-first CSS framework"
  homepage "https://tailwindcss.com"
  url "https://github.com/tailwindlabs/tailwindcss/archive/refs/tags/v3.4.13.tar.gz"
  sha256 "3ac83895e2351bac12479eaa1d4dffd5d6a929c82757521cbabbfebed85933da"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e71071caca32f5c7680148264c2f5b1cf363de6fa2921080ea951df5498ecba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e71071caca32f5c7680148264c2f5b1cf363de6fa2921080ea951df5498ecba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5999ac9eea04f9baf03bca00bc3f5dc3ef95799c77219f741c1b4ac9bc9b7c75"
    sha256 cellar: :any_skip_relocation, sonoma:        "1535e4d52f0074184e51332009403df09c477f7bc823ec20b86b519b30a195d5"
    sha256 cellar: :any_skip_relocation, ventura:       "e95ba9d678f0f9c20c916bef3f4b39e695b0a5b38b28e1230e2918f970937aa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ea7937dd6a453c185d03ed558cc747c31f1ee57e6c12dbc8732fc0ae9a55104"
  end

  depends_on "node" => :build

  def install
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build"

    cd "standalone-cli" do
      system "npm", "install", *std_npm_args(prefix: false)
      system "npm", "run", "build"
      os = OS.mac? ? "macos" : "linux"
      cpu = Hardware::CPU.arm? ? "arm64" : "x64"
      bin.install "dist/tailwindcss-#{os}-#{cpu}" => "tailwindcss"
    end
  end

  test do
    (testpath/"input.css").write("@tailwind base;")
    system bin/"tailwindcss", "-i", "input.css", "-o", "output.css"
    assert_predicate testpath/"output.css", :exist?
  end
end
