class Rpl < Formula
  include Language::Python::Virtualenv

  desc "Text replacement utility"
  homepage "https://github.com/rrthomas/rpl"
  url "https://files.pythonhosted.org/packages/40/ad/840b679493c49e0c4368662e2ddd6296f9bac41e8ee992e0d43d144b4f35/rpl-1.15.7.tar.gz"
  sha256 "5eadc62dad539d2e27a1b3c71c2905504a3dbe02380c6c98dbf8505ad9303510"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "083e8e4e93cf1cdc2d27927a5fcc9d940cf5836a627a56eb7909c53c2aec3cbb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "304dcb7bae1af1dd89e70a7f251b085e8cbdbdf854a380085a7455cf2a6cbd02"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0eafe2b59387da30fbb13720583057ca3918c640a65e29c1122e67a9ea88bbcc"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e88507cb5ba53208592f4af66acfd4ea87e12fe96518022fd62e48af4b6f158"
    sha256 cellar: :any_skip_relocation, ventura:        "dae63f9ab024feeff2322915a4d6f72305c6dd043f67241fc8f53fe9d7a1d107"
    sha256 cellar: :any_skip_relocation, monterey:       "7104efc1ff0ff1ae068c4d7909d507e10f57bb455ca06c5162af566929eccb4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c195d7aafecce96a9a509ef41ff8647cff2fc38d0886814d80ec6e92a4be02a"
  end

  depends_on "python@3.12"

  resource "chainstream" do
    url "https://files.pythonhosted.org/packages/44/fd/ec0c4df1e2b00080826b3e2a9df81c912c8dc7dbab757b55d68af3a51dcf/chainstream-1.0.1.tar.gz"
    sha256 "df4d8fd418b112690e0e6faa4cb6706962e4b6b95ff5c133890fd32157c8d3b7"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/3f/51/64256d0dc72816a4fe3779449627c69ec8fee5a5625fd60ba048f53b3478/regex-2024.7.24.tar.gz"
    sha256 "9cfd009eed1a46b27c14039ad5bbc5e71b6367c5b2e6d5f5da0ea91600817506"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test").write "I like water."

    system bin/"rpl", "-v", "water", "beer", "test"
    assert_equal "I like beer.", (testpath/"test").read
  end
end
