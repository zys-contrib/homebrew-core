class AnsibleCreator < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for scaffolding Ansible Content"
  homepage "https://ansible.readthedocs.io/projects/creator/"
  url "https://files.pythonhosted.org/packages/3e/a0/365dea170ef334b0fd666d75cac128b0e66ca59eb372ad11fcd8d98b2b93/ansible_creator-24.10.0.tar.gz"
  sha256 "b281d9b4a266c4f56f12a03ef67cc40904c31399ee4cf4799876e8fa8aad0543"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7b8d5acfb6cefeeb91d13411ab463f5d3eebe5ce3104801aca3eb7bb69f434b0"
    sha256 cellar: :any,                 arm64_sonoma:  "d90cac7771cd89850d1e5cd64374c0d27fb61848afa73da3d7b55f81222ebd54"
    sha256 cellar: :any,                 arm64_ventura: "49b6e701949d7cdbaec5d830e6918e6356543e249fe958e5f7e7c4556bc1ebff"
    sha256 cellar: :any,                 sonoma:        "b4d562e6e64481919b49383694ce2baef4d0281855cd4d8468281f0cf1609cb4"
    sha256 cellar: :any,                 ventura:       "51e262bb390cc1dc406a903e2bd406b3b1edc0cd46d62d388d9298980faf6c8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a2cd0c175bdaa99240445377a727e67bd60085acb08c53eb54eef77c6833a3e"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/ed/55/39036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5d/jinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b4/d2/38ff920762f2247c3af5cbbbbc40756f575d9692d381d7c520f45deb9b8f/markupsafe-3.0.1.tar.gz"
    sha256 "3e683ee4f5d0fa2dde4db77ed8dd8a876686e3fc417655c2ece9a90576905344"
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
