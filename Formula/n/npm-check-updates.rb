class NpmCheckUpdates < Formula
  desc "Find newer versions of dependencies than what your package.json allows"
  homepage "https://github.com/raineorshine/npm-check-updates"
  url "https://registry.npmjs.org/npm-check-updates/-/npm-check-updates-17.1.3.tgz"
  sha256 "c1406d101dd6de4635beb0bd8fe1d45175d1cd79bea8f3e1c3c6272c9fc696be"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df0a47029cf64fcb6815f548b9753aa87912a7b11f1ab8eab014b36e04a16e10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df0a47029cf64fcb6815f548b9753aa87912a7b11f1ab8eab014b36e04a16e10"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "df0a47029cf64fcb6815f548b9753aa87912a7b11f1ab8eab014b36e04a16e10"
    sha256 cellar: :any_skip_relocation, sonoma:        "78db67e094df8fb667e7328a6ac7b3eb4e67fe9ee317150c5376e931527aae99"
    sha256 cellar: :any_skip_relocation, ventura:       "78db67e094df8fb667e7328a6ac7b3eb4e67fe9ee317150c5376e931527aae99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df0a47029cf64fcb6815f548b9753aa87912a7b11f1ab8eab014b36e04a16e10"
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
