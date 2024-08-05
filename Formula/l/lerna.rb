class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-8.1.8.tgz"
  sha256 "f2404d1e5596ee7a6af9906bdd1b6365423ec16e75f55737336870be2a41b0b0"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "8ef9cd555e0e56ea0ba20d71959207930f5ac98d52abc8edac974637bd7933e6"
    sha256 cellar: :any,                 arm64_ventura:  "8ef9cd555e0e56ea0ba20d71959207930f5ac98d52abc8edac974637bd7933e6"
    sha256 cellar: :any,                 arm64_monterey: "8ef9cd555e0e56ea0ba20d71959207930f5ac98d52abc8edac974637bd7933e6"
    sha256 cellar: :any,                 sonoma:         "daaee64ba1d51295ecf68dcaf51266e31ad13ad80890b2ac546e7bd814753954"
    sha256 cellar: :any,                 ventura:        "daaee64ba1d51295ecf68dcaf51266e31ad13ad80890b2ac546e7bd814753954"
    sha256 cellar: :any,                 monterey:       "daaee64ba1d51295ecf68dcaf51266e31ad13ad80890b2ac546e7bd814753954"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7d1ad126628564dbfe06a6c7ca0e5489b4315dbb879b0477af6b3a6400040b2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lerna --version")

    output = shell_output("#{bin}/lerna init --independent 2>&1")
    assert_match "lerna success Initialized Lerna files", output
  end
end
