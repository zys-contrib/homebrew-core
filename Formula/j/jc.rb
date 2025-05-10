class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/1b/da/f6ec6a79f8dea70671f41d7162cfefdfe97e9c5b6c2227c1737183c05cd6/jc-1.25.5.tar.gz"
  sha256 "f8ac0e4bc427b0ee8a3bdb07a254cc9df6b6036cd440f6c425e2e519cdbda78a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0de81faab274ebbfa4289870a9ab9497059ec7a76af0e6f95ce5efc0ca3e9b8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0de81faab274ebbfa4289870a9ab9497059ec7a76af0e6f95ce5efc0ca3e9b8e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0de81faab274ebbfa4289870a9ab9497059ec7a76af0e6f95ce5efc0ca3e9b8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "cab2ae0a9da71eb21e2b0a553ced8f03953a277f74bcb97ce58ca207ab752224"
    sha256 cellar: :any_skip_relocation, ventura:       "cab2ae0a9da71eb21e2b0a553ced8f03953a277f74bcb97ce58ca207ab752224"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7a804ec72d181a9e05a1fcb095e633260203f0c3d6d30d57cc601f789064545"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0de81faab274ebbfa4289870a9ab9497059ec7a76af0e6f95ce5efc0ca3e9b8e"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/7c/2d/c3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84/pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/ea/46/f44d8be06b85bc7c4d8c95d658be2b68f27711f279bf9dd0612a5e4794f5/ruamel.yaml-0.18.10.tar.gz"
    sha256 "20c86ab29ac2153f80a428e1254a8adf686d3383df04490514ca3b79a362db58"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/50/05/51dcca9a9bf5e1bce52582683ce50980bcadbc4fa5143b9f2b19ab99958f/xmltodict-0.14.2.tar.gz"
    sha256 "201e7c28bb210e374999d1dde6382923ab0ed1a8a5faeece48ab525b7810a553"
  end

  def install
    virtualenv_install_with_resources

    man1.install "man/jc.1"
    generate_completions_from_executable(bin/"jc", "--bash-comp", shells: [:bash], shell_parameter_format: :none)
    generate_completions_from_executable(bin/"jc", "--zsh-comp", shells: [:zsh], shell_parameter_format: :none)
  end

  test do
    assert_equal "[{\"header1\":\"data1\",\"header2\":\"data2\"}]\n",
                  pipe_output("#{bin}/jc --csv", "header1, header2\n data1, data2")
  end
end
