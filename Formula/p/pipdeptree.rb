class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/74/ef/9158ee3b28274667986d39191760c988a2de22c6321be1262e21c8a19ccf/pipdeptree-2.26.1.tar.gz"
  sha256 "92a8f37ab79235dacb46af107e691a1309ca4a429315ba2a1df97d1cd56e27ac"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7474ec1ccbafd4ea823211e76c4763e16d61bd6c2a71d9defeffa8809f4f578a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7474ec1ccbafd4ea823211e76c4763e16d61bd6c2a71d9defeffa8809f4f578a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7474ec1ccbafd4ea823211e76c4763e16d61bd6c2a71d9defeffa8809f4f578a"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ffaf0dce132efa2a483e9713cd97032fff08c32cf977e8a5839ce36965aafa1"
    sha256 cellar: :any_skip_relocation, ventura:       "4ffaf0dce132efa2a483e9713cd97032fff08c32cf977e8a5839ce36965aafa1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7474ec1ccbafd4ea823211e76c4763e16d61bd6c2a71d9defeffa8809f4f578a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7474ec1ccbafd4ea823211e76c4763e16d61bd6c2a71d9defeffa8809f4f578a"
  end

  depends_on "python@3.13"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
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
