class PassImport < Formula
  include Language::Python::Virtualenv

  desc "Pass extension for importing data from most existing password managers"
  homepage "https://github.com/roddhjav/pass-import"
  url "https://files.pythonhosted.org/packages/f1/69/1d763287f49eb2d43f14280a1af9f6c2aa54a306071a4723a9723a6fb613/pass-import-3.5.tar.gz"
  sha256 "e3e5ec38f58511904a82214f8a80780729dfe84628d7c5d6b1cedee20ff3fb23"
  license "GPL-3.0-or-later"
  revision 4
  head "https://github.com/roddhjav/pass-import.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "e2263e0d94a2fd744c5748f9cd6a3966fc11ae33deca1ffb34e5997b47c2dafc"
    sha256 cellar: :any,                 arm64_sonoma:  "bf43aba56684c5ae1ff7be2b57090632c4a0a14dc7ae95223dbc89fe3e87b6e5"
    sha256 cellar: :any,                 arm64_ventura: "590406753c0fe6cb030055867702051112366e5f7d199f9341f860222b544513"
    sha256 cellar: :any,                 sonoma:        "175a6f288828c380052249095a738b05c5e81741ab3061ba975494433827aee1"
    sha256 cellar: :any,                 ventura:       "475bc32225a5f5b3edc4339b83e0a69b68a4156ea3e3bf7f2c994249a40fd817"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7bf7123a1879198f333664b612cb03ea9c7620ca00f41961b2fe6bb42b59127a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27a3f4f49b185cb3996cf80ee3026d58dec59e21da067caddf3832189d31c39f"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e4/33/89c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12d/charset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "pyaml" do
    url "https://files.pythonhosted.org/packages/c1/40/94f10f32ab952c5cca713d9ac9d8b2fdc37392d90eea403823eeac674c24/pyaml-25.5.0.tar.gz"
    sha256 "5799560c7b1c9daf35a7a4535f53e2c30323f74cbd7cb4f2e715b16dd681a58a"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e1/0a/929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8/requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8a/78/16493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0/urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  resource "zxcvbn" do
    url "https://files.pythonhosted.org/packages/ae/40/9366940b1484fd4e9423c8decbbf34a73bf52badb36281e082fe02b57aca/zxcvbn-4.5.0.tar.gz"
    sha256 "70392c0fff39459d7f55d0211151401e79e76fcc6e2c22b61add62900359c7c1"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    importers = shell_output("#{bin}/pimport --list-importers")
    assert_match(/The \d+ supported password managers are:/, importers)

    exporters = shell_output("#{bin}/pimport --list-exporters")
    assert_match(/The \d+ supported exporter password managers are/, exporters)
  end
end
