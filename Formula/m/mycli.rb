class Mycli < Formula
  include Language::Python::Virtualenv

  desc "CLI for MySQL with auto-completion and syntax highlighting"
  homepage "https://www.mycli.net/"
  url "https://files.pythonhosted.org/packages/09/3c/51d5b9a4a9bb9b0740ffb4d021cd57a5859558bfe77b051a1218e497c81b/mycli-1.27.2.tar.gz"
  sha256 "d11da4e614640096ea8066443d75946f8f281714ca30a89065c91fdc5f950b72"
  license "BSD-3-Clause"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5de5b321142932857f013a44b86faf31b4bc37772f3877cf04a32440bcc6d52e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "046dcf200432fe8f2c5fc6e3a6314c19f5a09b5284ae04078f6b06e47c324a54"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a98c689a7b7239bd825fabd67102ac38392a70e8c6fa3716eed47262ff2055e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "270d958e424a3116dee427644d89996b62dcce8f9bc784eb836a4e72d9d07a4f"
    sha256 cellar: :any_skip_relocation, sonoma:         "627ab3970c7364ed5cd56db9f3634707f25e351e408357c5fcccae96d05fe297"
    sha256 cellar: :any_skip_relocation, ventura:        "f49bb789f269b49dece786d7adebf6f622f4232aae5fee85374d8e280e3a77a8"
    sha256 cellar: :any_skip_relocation, monterey:       "41668c62b5cddf4d732072582406964d6ba8467c3eff37cb3f7b17525fa526ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d39bf63f29cb55c8102710c28725edaa56ccba2eea96314fedd330dc16362f1e"
  end

  depends_on "cryptography"
  depends_on "python@3.12"

  uses_from_macos "libffi"

  resource "cli-helpers" do
    url "https://files.pythonhosted.org/packages/ab/de/79529bd31c1664415d9554c0c5029f2137afe9808f35637bbcca977d9022/cli_helpers-2.3.1.tar.gz"
    sha256 "b82a8983ceee21f180e6fd0ddb7ca8dae43c40e920951e3817f996ab204dae6a"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/f5/c4/c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501/configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/47/6d/0279b119dafc74c1220420028d490c4399b790fc1256998666e3a341879f/prompt_toolkit-3.0.47.tar.gz"
    sha256 "1e1b29cb58080b1e69f207c893a1a7bf16d127a5c30c9d17a25a5d77792e5360"
  end

  resource "pyaes" do
    url "https://files.pythonhosted.org/packages/44/66/2c17bae31c906613795711fc78045c285048168919ace2220daa372c7d72/pyaes-1.6.1.tar.gz"
    sha256 "02c1b1405c38d3c370b085fb952dd8bea3fadcee6411ad99f312cc129c536d8f"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pymysql" do
    url "https://files.pythonhosted.org/packages/b3/8f/ce59b5e5ed4ce8512f879ff1fa5ab699d211ae2495f1adaa5fbba2a1eada/pymysql-1.1.1.tar.gz"
    sha256 "e127611aaf2b417403c60bf4dc570124aeb4a57f5f37b8e95ae399a42f904cd0"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/30/23/2f0a3efc4d6a32f3b63cdff36cd398d9701d26cda58e3ab97ac79fb5e60d/pyperclip-1.9.0.tar.gz"
    sha256 "b7de0142ddc81bfc5c7507eea19da920b92252b548b96186caf94a5e2527d310"
  end

  resource "sqlglot" do
    url "https://files.pythonhosted.org/packages/82/7c/a5b77005bdb521dba4f6e27f032dacc5a1b16f5ea40571fea92e422b2e0a/sqlglot-25.22.0.tar.gz"
    sha256 "f7b9291556ac73301c1a72dffe1802c0c2bf56c9d223382b3cc4cdfc2b9c26b8"
  end

  resource "sqlparse" do
    url "https://files.pythonhosted.org/packages/65/16/10f170ec641ed852611b6c9441b23d10b5702ab5288371feab3d36de2574/sqlparse-0.4.4.tar.gz"
    sha256 "d446183e84b8349fa3061f0fe7f06ca94ba65b426946ffebe6e3e8295332420c"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources

    # Click does not support bash version older than 4.4
    generate_completions_from_executable(bin/"mycli", shells:                 [:fish, :zsh],
                                                      shell_parameter_format: :click)
  end

  test do
    system bin/"mycli", "--help"
  end
end
