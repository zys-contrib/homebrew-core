class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/35/75/9d8b19b70987d67f28a9d2b6c3c56fd5cb08ff044b79c7a74f80e904f52f/translate_toolkit-3.14.5.tar.gz"
  sha256 "2846180b74a0b8cb7f51e7a70ae410c1310e9be37b7c6c849247c049e5c53dd0"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de26987a8e7e0879ea125e641988eab455a273d5b38238de8188786c4ce56c3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0a928edbec569da9cd34650c3ec242d7b73270c351285ee4914b7bbc0026194"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fdaacda69aac26658e9fab879b1a589ebc2d293c206fe7c6bd9051ba496c0536"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ed5c5f9337190f583163cc11fb14d6059f6ea4db31e6f4513caf12f3d2c13eb"
    sha256 cellar: :any_skip_relocation, ventura:       "6b028f4bc66100cb2dc1c63a9624ae278c0202a4e2eb4d764b5da1fd818c14b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3b54fb9a10dd45494e453a2e6ef87de763f2cf49259e8f19ae1fdd601733652"
  end

  depends_on "python@3.13"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "cwcwidth" do
    url "https://files.pythonhosted.org/packages/95/e3/275e359662052888bbb262b947d3f157aaf685aaeef4efc8393e4f36d8aa/cwcwidth-0.1.9.tar.gz"
    sha256 "f19d11a0148d4a8cacd064c96e93bca8ce3415a186ae8204038f45e108db76b8"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/e7/6b/20c3a4b24751377aaa6307eb230b66701024012c29dd374999cc92983269/lxml-5.3.0.tar.gz"
    sha256 "4e109ca30d1edec1ac60cdbe341905dc3b8f55b16855e03a54aaf59e51ec8c6f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    test_file = testpath/"test.po"
    touch test_file
    assert_match "Processing file : #{test_file}", shell_output("#{bin}/pocount --no-color #{test_file}")

    assert_match version.to_s, shell_output("#{bin}/pretranslate --version")
    assert_match version.to_s, shell_output("#{bin}/podebug --version")
  end
end
