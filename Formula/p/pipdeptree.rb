class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/7e/01/a3c3bdbf1bb50e0c675c76a65071fdbc80dbe92e8ec7959b7ba81c642769/pipdeptree-2.24.0.tar.gz"
  sha256 "d520e165535e217dd8958dfc14f1922efa0f6e4ff16126a61edb7ed6c538a930"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b7a0798324a8441d12bdfce3cd11af1b12ff1b5e478366449c8be532fb57154"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b7a0798324a8441d12bdfce3cd11af1b12ff1b5e478366449c8be532fb57154"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b7a0798324a8441d12bdfce3cd11af1b12ff1b5e478366449c8be532fb57154"
    sha256 cellar: :any_skip_relocation, sonoma:        "65ff974611d2283bef79292484b6c373de54696a87a53be7871840189354aa3f"
    sha256 cellar: :any_skip_relocation, ventura:       "65ff974611d2283bef79292484b6c373de54696a87a53be7871840189354aa3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b7a0798324a8441d12bdfce3cd11af1b12ff1b5e478366449c8be532fb57154"
  end

  depends_on "python@3.13"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "pipdeptree==#{version}", shell_output("#{bin}/pipdeptree --all")

    assert_empty shell_output("#{bin}/pipdeptree --user-only").strip

    assert_equal version.to_s, shell_output("#{bin}/pipdeptree --version").strip
  end
end
