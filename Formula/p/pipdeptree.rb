class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/0e/93/7ad37d2531445121642d529e196b9cc88b00816ffb99944f5edff2282624/pipdeptree-2.23.0.tar.gz"
  sha256 "09597cbee3f42857c8de78e51b7646d389a294b2faf4cd833a206e69a615ebcd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "59d630e30a35a286b795e1da4556f880f689349d60b02f405416a5f65f679d1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59d630e30a35a286b795e1da4556f880f689349d60b02f405416a5f65f679d1a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59d630e30a35a286b795e1da4556f880f689349d60b02f405416a5f65f679d1a"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb742e40ab7e5ee4f35ee769de01ea9f280588a8c1c1733d8f8bf9fef4050ece"
    sha256 cellar: :any_skip_relocation, ventura:        "fb742e40ab7e5ee4f35ee769de01ea9f280588a8c1c1733d8f8bf9fef4050ece"
    sha256 cellar: :any_skip_relocation, monterey:       "fb742e40ab7e5ee4f35ee769de01ea9f280588a8c1c1733d8f8bf9fef4050ece"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8114e99ecc8ea1e32f6cf16cc0ecef8c4cccb1b5f618872488a04794a553a0a"
  end

  depends_on "python@3.12"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
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
