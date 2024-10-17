class NpmCheckUpdates < Formula
  desc "Find newer versions of dependencies than what your package.json allows"
  homepage "https://github.com/raineorshine/npm-check-updates"
  url "https://registry.npmjs.org/npm-check-updates/-/npm-check-updates-17.1.4.tgz"
  sha256 "0dd5adab51e033dab4f5c2a7f9097cec2a9ff704c5933a1a34afaee695370e66"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d81ec15d8d6c8845cd1646491c221ce9affea17215dfbfbce5eb97dc80635aba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d81ec15d8d6c8845cd1646491c221ce9affea17215dfbfbce5eb97dc80635aba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d81ec15d8d6c8845cd1646491c221ce9affea17215dfbfbce5eb97dc80635aba"
    sha256 cellar: :any_skip_relocation, sonoma:        "6769d07f01f8630abfec7cff8845ee4738b3d302727669d2e860574fe324da66"
    sha256 cellar: :any_skip_relocation, ventura:       "6769d07f01f8630abfec7cff8845ee4738b3d302727669d2e860574fe324da66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d81ec15d8d6c8845cd1646491c221ce9affea17215dfbfbce5eb97dc80635aba"
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
