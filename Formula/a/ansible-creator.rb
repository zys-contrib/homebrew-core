class AnsibleCreator < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for scaffolding Ansible Content"
  homepage "https://ansible.readthedocs.io/projects/creator/"
  url "https://files.pythonhosted.org/packages/52/bc/32cbe5da6d0216d70f83e3f751b16b5cfe1500362fa07e12d1819afe2bc2/ansible_creator-25.0.0.tar.gz"
  sha256 "f3348e185ae9ec2fb522c4b4cb4eaa4eb67e7f53f767acbdfd6739f22421b8e2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "429dc82d87b1b3f1bd044fbf65087482139ee4793460ac8d2aaf9b65740d8118"
    sha256 cellar: :any,                 arm64_sonoma:  "82984adff03bd6d1e557bbe65e622d7a918637463d3c12e4928dd6996d9f5c16"
    sha256 cellar: :any,                 arm64_ventura: "74d01f08afdaceec5e8bc512bacc2389e78a53393466e1bbdb8d57ec3a32221b"
    sha256 cellar: :any,                 sonoma:        "d4cf52a179841d4f76d2e7e603ecc73546753f8efae12947e0115a5c13c51ac3"
    sha256 cellar: :any,                 ventura:       "8f58b659c2e070da08423c2c902e9d69e2db5d04ccf6a37bb57f9459fe8396ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8dfa6b2117e2fc1ee12827cd64d5dc914498ef1da3cc7bcab1afd6ac8353089a"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/af/92/b3130cbbf5591acf9ade8708c365f3238046ac7cb8ccba6e81abccb0ccff/jinja2-3.1.5.tar.gz"
    sha256 "8fefff8dc3034e27bb80d67c671eb8a9bc424c0ef4c0826edbff304cceff43bb"
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
