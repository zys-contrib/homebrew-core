class NpmCheckUpdates < Formula
  desc "Find newer versions of dependencies than what your package.json allows"
  homepage "https://github.com/raineorshine/npm-check-updates"
  url "https://registry.npmjs.org/npm-check-updates/-/npm-check-updates-17.1.8.tgz"
  sha256 "d62f794d6cb90de94085f168d9a17551246ba41a0d91ceac779966f379636957"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2be0549daa561ed107121bdc1d87a8930bef22058b8278772ca63287d27acd57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2be0549daa561ed107121bdc1d87a8930bef22058b8278772ca63287d27acd57"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2be0549daa561ed107121bdc1d87a8930bef22058b8278772ca63287d27acd57"
    sha256 cellar: :any_skip_relocation, sonoma:        "02d9569b433f9ebce27522af2f3c3d9ed030991c6369c2cb4185a8741b72968c"
    sha256 cellar: :any_skip_relocation, ventura:       "02d9569b433f9ebce27522af2f3c3d9ed030991c6369c2cb4185a8741b72968c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2be0549daa561ed107121bdc1d87a8930bef22058b8278772ca63287d27acd57"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    test_package_json = testpath/"package.json"
    test_package_json.write <<~EOS
      {
        "dependencies": {
          "express": "1.8.7",
          "lodash": "3.6.1"
        }
      }
    EOS

    system bin/"ncu", "-u"

    # Read the updated package.json to get the new dependency versions
    updated_package_json = JSON.parse(test_package_json.read)
    updated_express_version = updated_package_json["dependencies"]["express"]
    updated_lodash_version = updated_package_json["dependencies"]["lodash"]

    # Assert that both dependencies have been updated to higher versions
    assert Gem::Version.new(updated_express_version) > Gem::Version.new("1.8.7"),
      "Express version not updated as expected"
    assert Gem::Version.new(updated_lodash_version) > Gem::Version.new("3.6.1"),
      "Lodash version not updated as expected"
  end
end
