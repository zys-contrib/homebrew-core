class Dotbot < Formula
  include Language::Python::Virtualenv

  desc "Tool that bootstraps your dotfiles"
  homepage "https://github.com/anishathalye/dotbot"
  url "https://files.pythonhosted.org/packages/f9/67/793d72c813a4781227963f77d353db4830760ed9a40a5752330f2d7c10d9/dotbot-1.20.3.tar.gz"
  sha256 "6c4ec52e498964082e1048a26f9b1e5fcebe0b384f8b3cefb90525c2d8c70030"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c9e41836c89680b56a0d0b043a8db76e7757e16be17e148847034f2c2a34cfd0"
    sha256 cellar: :any,                 arm64_sonoma:  "0299a9f7abed21f432d436f1cdff566cd3a3268bf0631056c70568bbd7a48c2e"
    sha256 cellar: :any,                 arm64_ventura: "e44eb4fc28e2df28b9a9d94802f2258d19e22ac5425b8f9d7e4bef4c8f611e89"
    sha256 cellar: :any,                 sonoma:        "84daafacf6bf396b92ab61cb267f5459f21be02d892a7671d98c1ec58720dbd7"
    sha256 cellar: :any,                 ventura:       "8e4dbba4cfda1be17ead0ae10c5acf00bf129db19691df610b391bb224113364"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4d36c237e92775810efb21ceefdd274a6cb0a52fc0353e0571ee6ee8406da1d"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"install.conf.yaml").write <<~YAML
      - create:
        - brew
        - .brew/test
    YAML

    output = shell_output("#{bin}/dotbot -c #{testpath}/install.conf.yaml")
    assert_match "All tasks executed successfully", output
    assert_predicate testpath/"brew", :exist?
    assert_predicate testpath/".brew/test", :exist?
  end
end
