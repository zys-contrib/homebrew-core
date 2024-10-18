class AnsibleCreator < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for scaffolding Ansible Content"
  homepage "https://ansible.readthedocs.io/projects/creator/"
  url "https://files.pythonhosted.org/packages/64/32/a049dcd08d1140e9615e1961d69fccd0286ab0f3e98202e678b2d83f5eb2/ansible_creator-24.10.1.tar.gz"
  sha256 "a4ccc401a0b33903e39a7b5e23b5fd06fd2d486dcb4fd00772d47da5deeb8b8e"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "3964bbb3a2d7d4523ae8543d0c572bfbbf191f80f587fe6641a9dc4c00cbe9bc"
    sha256 cellar: :any,                 arm64_sonoma:  "d1a494ed63365018c4c15596137099876db0827764609a4de4c5194e1ffa24af"
    sha256 cellar: :any,                 arm64_ventura: "b4c598b53bb161f50885b4c40307a064146b0518880b1121de79f3c8d89feae4"
    sha256 cellar: :any,                 sonoma:        "875a7b4af9ac4a515e8d5d6e66fb7fbff68e5a50dfa9157759cbf7a2c3047e61"
    sha256 cellar: :any,                 ventura:       "f6e8232d16c69bb7789e3c42f4a5de8da3257959dce297267635dde0fc89eeac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d36e6d5f21849c793652874b599098562548b130228ad84dea4944a91fa6e51"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/ed/55/39036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5d/jinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["ANSIBLE_REMOTE_TEMP"] = testpath/"tmp"
    system bin/"ansible-creator", "init", "examplenamespace.examplename",
      "--init-path", testpath/"example"
    assert_predicate testpath/"example/galaxy.yml", :exist?

    assert_match version.to_s, shell_output("#{bin}/ansible-creator --version")
  end
end
