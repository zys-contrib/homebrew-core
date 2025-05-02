class CryticCompile < Formula
  include Language::Python::Virtualenv

  desc "Abstraction layer for smart contract build systems"
  homepage "https://github.com/crytic/crytic-compile"
  url "https://files.pythonhosted.org/packages/78/9b/6834afa2cc6fb3d958027e4c9c24c09735f9c6caeef4e205c22838f772bf/crytic_compile-0.3.10.tar.gz"
  sha256 "0d7e03b4109709dd175a4550345369548f99fc1c96183c34ccc4dd21a7c41601"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/crytic-compile.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb1b7b76c5da7a7f50b8b1d0b6b2620a40b945d8d583c8312f2e7b61747f98b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69428157d16fe956265d3e5f01147ec876e9ed07d74ba0166fdb2970c664029d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "69a4abf80f6a141dd06d1347a7c91a1e55795d70af78b6c9f8074a01a5af6000"
    sha256 cellar: :any_skip_relocation, sonoma:        "de4b9c3f5905de7aa7f1ed7428be5ec983fd9b757cceb7db946a2ac8545b3dbf"
    sha256 cellar: :any_skip_relocation, ventura:       "228587aadd718028a5cea30b87f7a819aa7720c582df4d0fcc9da00b330888ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf606898eb6dfcb6c8671130f0f2bc2ff7dd73f304e78c352678e4fda7c12599"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ce951fce63c9eebe695468139d77405580b066d860bb5a9b37176966d8164d2"
  end

  depends_on "python@3.13"

  resource "cbor2" do
    url "https://files.pythonhosted.org/packages/e4/aa/ba55b47d51d27911981a18743b4d3cebfabccbb0598c09801b734cec4184/cbor2-5.6.5.tar.gz"
    sha256 "b682820677ee1dbba45f7da11898d2720f92e06be36acec290867d5ebf3d7e09"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/44/e6/099310419df5ada522ff34ffc2f1a48a11b37fc6a76f51a6854c182dbd3e/pycryptodome-3.22.0.tar.gz"
    sha256 "fd7ab568b3ad7b77c908d7c3f7e167ec5a8f035c64ff74f10d47a4edd043d723"
  end

  resource "solc-select" do
    url "https://files.pythonhosted.org/packages/e0/55/55b19b5f6625e7f1a8398e9f19e61843e4c651164cac10673edd412c0678/solc_select-1.1.0.tar.gz"
    sha256 "94fb6f976ab50ffccc5757d5beaf76417b27cbe15436cfe2b30cdb838f5c7516"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    resource "testdata" do
      url "https://github.com/crytic/slither/raw/d0a4f5595d7177b3b7d4bd35e1384bf35ebc22d4/tests/ast-parsing/compile/variable-0.8.0.sol-0.8.15-compact.zip", using: :nounzip
      sha256 "2f165f629882d0250d03a56cb67a84e9741375349195915a04385b0666394478"
    end

    resource("testdata").stage do
      system bin/"crytic-compile", "variable-0.8.0.sol-0.8.15-compact.zip",
             "--export-format=solc", "--export-dir=#{testpath}/export"
    end

    assert_path_exists testpath/"export/combined_solc.json"
  end
end
