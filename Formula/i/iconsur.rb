class Iconsur < Formula
  include Language::Python::Virtualenv

  desc "macOS Big Sur Adaptive Icon Generator"
  homepage "https://github.com/rikumi/iconsur"
  # Keep extra_packages in pypi_formula_mappings.json aligned with
  # https://github.com/rikumi/iconsur/blob/#{version}/src/fileicon.sh#L230
  url "https://registry.npmjs.org/iconsur/-/iconsur-1.7.0.tgz"
  sha256 "d732df6bbcaf1418c6f46f9148002cbc1243814692c1c0e5c0cebfcff001c4a1"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e15acf0ca74a39af601070861cc784c36a10d6ec8b423723e42f18560bb20587"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "41e638854049735d75d8a5817f49c5751f423ecb8d4da508fa2546c0af6092e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04e27b7499dedbce8368ea0bf753b37dc0ba0aa1e40afa60fbe1200f7c07363f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc350d8b15f1417e7b52a8ea40b7a3331d9153194a43e332878d5ea89dd1fb12"
    sha256 cellar: :any_skip_relocation, sonoma:         "44693cd5a395695bf5900720a3049b9d87753c3b36d16807acf012bba65b422f"
    sha256 cellar: :any_skip_relocation, ventura:        "83853903cd670285e187e2119a6ec16dea4a834bc36558a5821354d03391600c"
    sha256 cellar: :any_skip_relocation, monterey:       "036e74c813e250b333a2ad2f767cfda92deacc144dad0f30e12ec6bc414ef439"
  end

  depends_on :macos
  depends_on "node"

  # Uses /usr/bin/python on older macOS. Otherwise, it will use python3 from PATH.
  # Since fileicon.sh runs `pip3 install --user` to install any missing packages,
  # this causes issues if a user has Homebrew Python installed (EXTERNALLY-MANAGED).
  # We instead prepare a virtualenv with all missing packages.
  on_monterey :or_newer do
    depends_on "python@3.13"
  end

  resource "pyobjc-core" do
    url "https://files.pythonhosted.org/packages/b7/40/a38d78627bd882d86c447db5a195ff307001ae02c1892962c656f2fd6b83/pyobjc_core-10.3.1.tar.gz"
    sha256 "b204a80ccc070f9ab3f8af423a3a25a6fd787e228508d00c4c30f8ac538ba720"
  end

  resource "pyobjc-framework-cocoa" do
    url "https://files.pythonhosted.org/packages/a7/6c/b62e31e6e00f24e70b62f680e35a0d663ba14ff7601ae591b5d20e251161/pyobjc_framework_cocoa-10.3.1.tar.gz"
    sha256 "1cf20714daaa986b488fb62d69713049f635c9d41a60c8da97d835710445281a"
  end

  def install
    system "npm", "install", *std_npm_args

    if MacOS.version >= :monterey
      venv = virtualenv_create(libexec/"venv", "python3.13")
      venv.pip_install resources
      bin.install Dir["#{libexec}/bin/*"]
      bin.env_script_all_files libexec/"bin", PATH: "#{venv.root}/bin:${PATH}"
    else
      bin.install_symlink Dir["#{libexec}/bin/*"]
    end
  end

  test do
    mkdir testpath/"Test.app"
    system bin/"iconsur", "set", testpath/"Test.app", "-k", "AppleDeveloper"
    system bin/"iconsur", "cache"
    system bin/"iconsur", "unset", testpath/"Test.app"
  end
end
