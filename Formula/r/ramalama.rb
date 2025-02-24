class Ramalama < Formula
  include Language::Python::Virtualenv

  desc "Goal of RamaLama is to make working with AI boring"
  homepage "https://github.com/containers/ramalama"
  url "https://files.pythonhosted.org/packages/c2/c5/d4878a1f888a6c2272c06c7343ab11b92f6a450fdc85e872541afcfca9de/ramalama-0.6.2.tar.gz"
  sha256 "2f1763b38bcabc20bbee41b3bf0b0fa3c31e19c30659333a2f0ec368c0a28f4c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67aa8b9f4e99b8ba7a66a015c20852deaca6ed43ce00476faf49ce45a991a97e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67aa8b9f4e99b8ba7a66a015c20852deaca6ed43ce00476faf49ce45a991a97e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "67aa8b9f4e99b8ba7a66a015c20852deaca6ed43ce00476faf49ce45a991a97e"
    sha256 cellar: :any_skip_relocation, sonoma:        "040a81abcba18d77d06fafa9060ce576910088d9987ef39e7a5c8f6f9e5497f3"
    sha256 cellar: :any_skip_relocation, ventura:       "040a81abcba18d77d06fafa9060ce576910088d9987ef39e7a5c8f6f9e5497f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07ed70afbcfe838aabc24826f1257921e3976a00fc0612ff81849ecaff03a141"
  end

  depends_on "python@3.13"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/0c/be/6c23d80cb966fb8f83fb1ebfb988351ae6b0554d0c3a613ee4531c026597/argcomplete-3.5.3.tar.gz"
    sha256 "c12bf50eded8aebb298c7b7da7a5ff3ee24dffd9f5281867dfe1424b58c55392"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "invalidllm was not found", shell_output("#{bin}/ramalama run invalidllm 2>&1", 1)

    system bin/"ramalama", "pull", "tinyllama"
    list_output = shell_output("#{bin}/ramalama list")
    assert_match "tinyllama", list_output

    inspect_output = shell_output("#{bin}/ramalama inspect tinyllama")
    assert_match "Format: GGUF", inspect_output

    assert_match version.to_s, shell_output("#{bin}/ramalama version")
  end
end
