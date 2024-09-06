class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/refs/tags/v10.0.0.tar.gz"
  sha256 "096b78d1ccb4ad006293ed1e2b258925d99565449d374f5745ee374dc6f07a23"
  license "MIT"
  head "https://github.com/tj/n.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "89304b0eb5dba92060a594d9761699fd334efd4fc884df2fbf4afa476e55f36a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89304b0eb5dba92060a594d9761699fd334efd4fc884df2fbf4afa476e55f36a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89304b0eb5dba92060a594d9761699fd334efd4fc884df2fbf4afa476e55f36a"
    sha256 cellar: :any_skip_relocation, sonoma:         "10b735f6bbfa0c30b7208446d8f87804cadca713dba7a740d8fde2bd4c363583"
    sha256 cellar: :any_skip_relocation, ventura:        "10b735f6bbfa0c30b7208446d8f87804cadca713dba7a740d8fde2bd4c363583"
    sha256 cellar: :any_skip_relocation, monterey:       "10b735f6bbfa0c30b7208446d8f87804cadca713dba7a740d8fde2bd4c363583"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89304b0eb5dba92060a594d9761699fd334efd4fc884df2fbf4afa476e55f36a"
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
