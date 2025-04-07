class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-1.46.1.tgz"
  sha256 "0949be4bdf6375b0cc577caec9120ed488494a97b267bf8ee914accbeba83959"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fe7dccc87e6e5efa371936ed551b519232a95bd37d29df247a8ed7a1b21c4acb"
    sha256 cellar: :any,                 arm64_sonoma:  "fe7dccc87e6e5efa371936ed551b519232a95bd37d29df247a8ed7a1b21c4acb"
    sha256 cellar: :any,                 arm64_ventura: "fe7dccc87e6e5efa371936ed551b519232a95bd37d29df247a8ed7a1b21c4acb"
    sha256 cellar: :any,                 sonoma:        "ededdb60f44d4a17daa02515369990a3ef9160245189e7cff89d0879643de95a"
    sha256 cellar: :any,                 ventura:       "ededdb60f44d4a17daa02515369990a3ef9160245189e7cff89d0879643de95a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a72fd9765b648d5af03f20eed113476bf22391984a58dda4ba83299f73c6d9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffc0f9712be7cb624941c4760dd355e592b7342c594a5f471be1400746fee757"
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
