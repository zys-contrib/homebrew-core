class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-2.0.0.tgz"
  sha256 "402a33d8b4e9d4b672eeaf783de5e61daa067907b81ba87396746f76c6b8bc85"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "455c3aa3bde815c831b8e03447809673e4a756c926011673efad8a605a3cbdc0"
    sha256 cellar: :any,                 arm64_sonoma:  "455c3aa3bde815c831b8e03447809673e4a756c926011673efad8a605a3cbdc0"
    sha256 cellar: :any,                 arm64_ventura: "455c3aa3bde815c831b8e03447809673e4a756c926011673efad8a605a3cbdc0"
    sha256 cellar: :any,                 sonoma:        "11d8ad1ef59242cea86f19ccd3424f151a9980276440cc564b5006e235927c0a"
    sha256 cellar: :any,                 ventura:       "11d8ad1ef59242cea86f19ccd3424f151a9980276440cc564b5006e235927c0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ad0071081a6592b94e89a3611a08475426e8a4b3eff1a409eba84914c71d152"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b4853fbda213bd746053593104742db6496dd58c1ff16e2788909bf0bf3375f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jsrepo --version")

    system bin/"jsrepo", "build"
    assert_match "\"categories\": []", (testpath/"jsrepo-manifest.json").read
  end
end
