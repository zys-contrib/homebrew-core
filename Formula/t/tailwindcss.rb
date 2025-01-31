class Tailwindcss < Formula
  desc "Utility-first CSS framework"
  homepage "https://tailwindcss.com"
  url "https://registry.npmjs.org/tailwindcss/-/tailwindcss-4.0.2.tgz"
  sha256 "4636533065a1ac058611aebfde93ef16d8197b162447cf212e17468a07f5a93e"
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
    sha256                               arm64_sequoia: "6da14e78515f690b7168e86d4503279785d5eea9ff55d06ad2b3e56d752fbfa9"
    sha256                               arm64_sonoma:  "fc1e38cf04568397783bea14face64aea706ff43092d91d20a404539d76f3ee9"
    sha256                               arm64_ventura: "522a009491e3ac56679bc4bd5d752c6bacf8e10a9ef58cb72097c89cde765804"
    sha256                               sonoma:        "b2d4a97eff720a18131df29f4aa735e447eade15f6023441195cf80e2406f188"
    sha256                               ventura:       "6aaa4bc775eb2f316b58eb5a7c40bc7d455d93930dd87c080fc8fa3b6a1a4255"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b1846ad51121dc222890f426ba432e4d966baafcfd8b0004c9fe97c234c0b58"
  end

  depends_on "node"

  resource "tailwind-cli" do
    url "https://registry.npmjs.org/@tailwindcss/cli/-/cli-4.0.2.tgz"
    sha256 "1f0923f621c91729ae5469670c5fa3e34b184162a251369ffac0e77b60f9e4c6"
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
