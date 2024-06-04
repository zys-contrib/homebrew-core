class AnsibleCreator < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for scaffolding Ansible Content"
  homepage "https://ansible.readthedocs.io/projects/creator/"
  url "https://files.pythonhosted.org/packages/f6/7d/72547d62b755884eec83efa86cb59890ac544e321b4854335af472fdd0b2/ansible_creator-24.6.0.tar.gz"
  sha256 "dd5633623c2fd53f20e2d77a0b8b3616b48b3474df91ce4d17a40bf763906079"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b48b168c5796d3602b410d48d0076161aa2a2662c5bcbfd3cf25cb84d6809d47"
    sha256 cellar: :any,                 arm64_ventura:  "6c1f570137043cae91f0bf71bab7f55a4ecf2c473b48c50a4677a8d1927e23a2"
    sha256 cellar: :any,                 arm64_monterey: "80ddde72257166ca7192935f60b4ca78f6872e9c4e968e69029bf096e25e9160"
    sha256 cellar: :any,                 sonoma:         "3580a2bc61509fe07cecba3db55a121b8e7f2f49822e5eae8f8a7810f6262800"
    sha256 cellar: :any,                 ventura:        "fdc7d0343733c36cc627562395318a9cef04f5f1c53cb35f62f25859df92452f"
    sha256 cellar: :any,                 monterey:       "13857bede18e944db5ec1e5fe4197f87b2fbde0fb0027f173c01d8fc0237b3d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d7c4db38cfc69f4d038ac9658d919e73124081211e7b975aa9340c8529ba37f"
  end

  depends_on "libyaml"
  depends_on "python@3.12"

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/ed/55/39036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5d/jinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/87/5b/aae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02d/MarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["ANSIBLE_REMOTE_TEMP"] = testpath/"tmp"
    system bin/"ansible-creator", "init", "exampleNamespace.exampleName",
      "--init-path", testpath/"example"
    assert_predicate testpath/"example/galaxy.yml", :exist?
  end
end
