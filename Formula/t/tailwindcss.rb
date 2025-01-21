class Tailwindcss < Formula
  desc "Utility-first CSS framework"
  homepage "https://tailwindcss.com"
  url "https://registry.npmjs.org/tailwindcss/-/tailwindcss-4.0.0.tgz"
  sha256 "72309ed7264bb66a0e4ed4171a064f9f4ea3b92906afe67b8afedbd8f9e78b28"
  license "MIT"

  livecheck do
    url "https://github.com/tailwindlabs/tailwindcss"
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6642f35504e8ab8ce029025e265972bb9a74d9030bd879973388ba245f5707ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6642f35504e8ab8ce029025e265972bb9a74d9030bd879973388ba245f5707ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6642f35504e8ab8ce029025e265972bb9a74d9030bd879973388ba245f5707ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "470d9bbfd904d02d77d565faa66afddcb033b7030ff41baf28ad47294c65c4b5"
    sha256 cellar: :any_skip_relocation, ventura:       "470d9bbfd904d02d77d565faa66afddcb033b7030ff41baf28ad47294c65c4b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6642f35504e8ab8ce029025e265972bb9a74d9030bd879973388ba245f5707ce"
  end

  depends_on "node"

  resource "tailwind-cli" do
    url "https://registry.npmjs.org/@tailwindcss/cli/-/cli-4.0.0.tgz"
    sha256 "a6a772944d048966e9db2bdc7521053ea3d8bd06cfdff7931fdc4bb2313e6369"
  end

  def install
    # install the dedicated tailwind-cli package
    resource("tailwind-cli").stage do
      system "npm", "install", *std_npm_args
    end

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"input.css").write("@tailwind base;")
    system bin/"tailwindcss", "-i", "input.css", "-o", "output.css"
    assert_path_exists testpath/"output.css"
  end
end
