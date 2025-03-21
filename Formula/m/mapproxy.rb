class Mapproxy < Formula
  include Language::Python::Virtualenv

  desc "Accelerating web map proxy"
  # `mapproxy.org` is 404, upstream bug report, https://github.com/mapproxy/mapproxy/issues/983
  homepage "https://github.com/mapproxy/mapproxy"
  url "https://files.pythonhosted.org/packages/9c/cb/24c55ea8c48f8ed3a2db5463df495088c9f334df40750f9e83895f39d785/mapproxy-4.0.0.tar.gz"
  sha256 "b45255d7e202cadb3560e5ac37f9a5121242c205d635bc85e7843b59c8f8de0c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d73b196aba9f5ca797743bbfc74e086196b00a937c4e445e4d06046ccf976ede"
    sha256 cellar: :any,                 arm64_sonoma:  "6475d9769844ab94913ca42c34cd494e4b97cae764a2a09b412a0205e7bf1c3b"
    sha256 cellar: :any,                 arm64_ventura: "cf7c8e051e488ff15f75618bc678c7a3b889e07c7f18467f5d707498fc073ffb"
    sha256 cellar: :any,                 sonoma:        "8e24edc8e3de910c0855f5df5b67281f17e05c8c8dbe4e1a57bf949ba6f05576"
    sha256 cellar: :any,                 ventura:       "4c626a416b3a28e989fa55853db72ac4bbca56d91482b5225adc5ce1b0d26240"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33783a94b7d3c738e599754f1b5abe1550371244df3219263a62e35291beaa8c"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "pillow"
  depends_on "proj"
  depends_on "python@3.13"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/5a/b0/1367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24/attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/a7/b2/4140c69c6a66432916b26158687e821ba631a4c9273c474343badf84d3ba/future-1.0.0.tar.gz"
    sha256 "bd2968309307861edae1458a4f8a4f3598c03be43b97521076aebf5d94c07b05"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/38/2e/03362ee4034a4c917f697890ccd4aec0800ccf9ded7f511971c75451deec/jsonschema-4.23.0.tar.gz"
    sha256 "d71497fef26351a33265337fa77ffeb82423f3ea21283cd9467bb03999266bc4"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/10/db/58f950c996c793472e336ff3655b13fbcf1e3b359dcf52dcf3ed3b52c352/jsonschema_specifications-2024.10.1.tar.gz"
    sha256 "0f38b83639958ce1152d02a7f062902c41c8fd20d558b0c34344292d417ae272"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "pyproj" do
    url "https://files.pythonhosted.org/packages/67/10/a8480ea27ea4bbe896c168808854d00f2a9b49f95c0319ddcbba693c8a90/pyproj-3.7.1.tar.gz"
    sha256 "60d72facd7b6b79853f19744779abcd3f804c4e0d4fa8815469db20c9f640a47"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/2f/db/98b5c277be99dd18bfd91dd04e1b759cad18d1a338188c936e92f921c7e2/referencing-0.36.2.tar.gz"
    sha256 "df2e89862cd09deabbdba16944cc3f10feb6b3e6f18e902f7cc25609a34775aa"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/0a/79/2ce611b18c4fd83d9e3aecb5cba93e1917c050f556db39842889fa69b79f/rpds_py-0.23.1.tar.gz"
    sha256 "7f3240dcfa14d198dba24b8b9cb3b108c06b68d45b7babd9eefc1038fdf7e707"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/9f/69/83029f1f6300c5fb2471d621ab06f6ec6b3324685a2ce0f9777fd4a8b71e/werkzeug-3.1.3.tar.gz"
    sha256 "60723ce945c19328679790e3282cc758aa4a6040e4bb330f53d30fa546d44746"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"mapproxy-util", "create", "-t", "base-config", testpath
    assert_path_exists testpath/"seed.yaml"
  end
end
