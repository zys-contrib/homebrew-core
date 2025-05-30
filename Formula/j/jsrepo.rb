class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-2.3.1.tgz"
  sha256 "6b84132c41811e67d66c9c0643e72623bfbe301559f23b062a63870a11cfb90d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "61c05108ea5115eda0cf8ce52c0de7c1ce39fcc87bf43ab8c14c3b44c57bfd22"
    sha256 cellar: :any,                 arm64_sonoma:  "61c05108ea5115eda0cf8ce52c0de7c1ce39fcc87bf43ab8c14c3b44c57bfd22"
    sha256 cellar: :any,                 arm64_ventura: "61c05108ea5115eda0cf8ce52c0de7c1ce39fcc87bf43ab8c14c3b44c57bfd22"
    sha256 cellar: :any,                 sonoma:        "d8b0bc591ae06cf1d084dca0ce60d0e40ee59bd354fd462b6b9331810978c80f"
    sha256 cellar: :any,                 ventura:       "d8b0bc591ae06cf1d084dca0ce60d0e40ee59bd354fd462b6b9331810978c80f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00d069926ea7c201c20362428ff1e82db52511f63d96e4bcaac19882815b0cce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e14850f5e4400c11a2a9d20b2648ab20aa8c8357a94f35b8c33513a824787ca9"
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
