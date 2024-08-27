class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-6.0.0.tgz"
  sha256 "2e30ad57d2b93b0debdde67aae2996f29e77c82164ff8d335ec1ecfa7c5391e8"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c10066ebf73e8ef43a34a5c0c00f05426055d588a0a40aeded7a478adae03f1d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c10066ebf73e8ef43a34a5c0c00f05426055d588a0a40aeded7a478adae03f1d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c10066ebf73e8ef43a34a5c0c00f05426055d588a0a40aeded7a478adae03f1d"
    sha256 cellar: :any_skip_relocation, sonoma:         "711e8612556f48965b49bb973bbf71b5bcf25a032dcdbb2eb51622f9f9f6a399"
    sha256 cellar: :any_skip_relocation, ventura:        "711e8612556f48965b49bb973bbf71b5bcf25a032dcdbb2eb51622f9f9f6a399"
    sha256 cellar: :any_skip_relocation, monterey:       "711e8612556f48965b49bb973bbf71b5bcf25a032dcdbb2eb51622f9f9f6a399"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ead452b093e4ac86fb46f96061661509a5092c11809ba25b75ef8b19e033296a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error: Invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end
