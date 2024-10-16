class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-17.10.0.tgz"
  sha256 "1073f1e057022afb219501b51a6eb5fd36ea5c3ae2c7215b7e272dea19046e3c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "425bb9b83f417bf30157e5630542e076c9c31ba3dc5dbf16d6db03a5532bc38a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "425bb9b83f417bf30157e5630542e076c9c31ba3dc5dbf16d6db03a5532bc38a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "425bb9b83f417bf30157e5630542e076c9c31ba3dc5dbf16d6db03a5532bc38a"
    sha256 cellar: :any_skip_relocation, sonoma:        "358f948b20ff79e4879d28767d7f79ca5a5c3501bfd63f5e60d42d7b8400873f"
    sha256 cellar: :any_skip_relocation, ventura:       "358f948b20ff79e4879d28767d7f79ca5a5c3501bfd63f5e60d42d7b8400873f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "425bb9b83f417bf30157e5630542e076c9c31ba3dc5dbf16d6db03a5532bc38a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/release-it -v")
    (testpath/"package.json").write("{\"name\":\"test-pkg\",\"version\":\"1.0.0\"}")
    assert_match(/Let's release test-pkg.+\(1\.0\.0\.\.\.1\.0\.1\).+Empty changelog.+Done \(in \d+s\.\)/m,
      shell_output("#{bin}/release-it --npm.skipChecks --no-npm.publish --ci"))
    assert_match "1.0.1", (testpath/"package.json").read
  end
end
