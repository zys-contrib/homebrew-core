class Tailwindcss < Formula
  desc "Utility-first CSS framework"
  homepage "https://tailwindcss.com"
  url "https://registry.npmjs.org/tailwindcss/-/tailwindcss-4.0.3.tgz"
  sha256 "8b5a00d0c29cfce9ec97cde2144a40a279c133a42074f5d1d9958b8efee1495a"
  license "MIT"
  head "https://github.com/tailwindlabs/tailwindcss.git", branch: "next"

  # There can be a notable gap between when a version is added to npm and the
  # GitHub release is created, so we check the "latest" release on GitHub
  # instead of the default `Npm` check for the `stable` URL.
  livecheck do
    url :head
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sequoia: "5bf65671f1afd586eccf17327883bfa5cd74c5f0d85ad6f3b1d7b08a03cd6f08"
    sha256                               arm64_sonoma:  "dbcf8fbd257414979d4c810ac99afcb4422e095dfe285747076f2bf0f971ef53"
    sha256                               arm64_ventura: "bbf02255069862abffd913403a13e0b53ef964896834a0f20870e8df2cfdc6bb"
    sha256                               sonoma:        "1b77b59706b439287a0fbd18c66bf40fee5c1c8b99449cbd37112d30a866126a"
    sha256                               ventura:       "29e42290b9514fdbfab6cbda12f409e7e12ba2acae610cec265cb1229e32a032"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37f4fd5fc54c8a438815a152f760c99d176c9aac95a6a288467d249edadf1d86"
  end

  depends_on "node"

  resource "tailwind-cli" do
    url "https://registry.npmjs.org/@tailwindcss/cli/-/cli-4.0.3.tgz"
    sha256 "d9df4e36cd823bbf90aeb9f7dc8e1bd1886501ef0ff51cba83526d29a41d5402"
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
