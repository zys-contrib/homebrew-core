class NpmCheckUpdates < Formula
  desc "Find newer versions of dependencies than what your package.json allows"
  homepage "https://github.com/raineorshine/npm-check-updates"
  url "https://registry.npmjs.org/npm-check-updates/-/npm-check-updates-17.1.13.tgz"
  sha256 "7ff254329165df82a27e85bc58547a500481016ed4758f7f2eaab49208385554"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd4dd15f6ae8b96ad32267ca1cd92c5ad0738373e059f78f6855d61646651683"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd4dd15f6ae8b96ad32267ca1cd92c5ad0738373e059f78f6855d61646651683"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cd4dd15f6ae8b96ad32267ca1cd92c5ad0738373e059f78f6855d61646651683"
    sha256 cellar: :any_skip_relocation, sonoma:        "86ab97ee26f679ed71fd159ebbb8db36f441a6f99e9ab1a42cb5d55b0a0f0a6f"
    sha256 cellar: :any_skip_relocation, ventura:       "86ab97ee26f679ed71fd159ebbb8db36f441a6f99e9ab1a42cb5d55b0a0f0a6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd4dd15f6ae8b96ad32267ca1cd92c5ad0738373e059f78f6855d61646651683"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    test_package_json = testpath/"package.json"
    test_package_json.write <<~JSON
      {
        "dependencies": {
          "express": "1.8.7",
          "lodash": "3.6.1"
        }
      }
    JSON

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
