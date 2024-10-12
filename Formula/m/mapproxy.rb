class Mapproxy < Formula
  include Language::Python::Virtualenv

  desc "Accelerating web map proxy"
  # `mapproxy.org` is 404, upstream bug report, https://github.com/mapproxy/mapproxy/issues/983
  homepage "https://github.com/mapproxy/mapproxy"
  url "https://files.pythonhosted.org/packages/bd/23/7051a8b1226e026df32669c059e3a63a9fd9dbe93ffd2af190f3e6d80825/MapProxy-3.0.1.tar.gz"
  sha256 "d92a347b954359d7b7ddb364b1d87375a88ea785e41dcc942de0627d5e4eb4a3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "c45785fdc0fb887b491f6e59a331c6e2f15b7a6d4d1e212ee7a80aed20ca603a"
    sha256 cellar: :any,                 arm64_sonoma:   "b2a4db9ae55eed18dcc9b5f992265cd507f63157f5bd258441ccee863103ca1e"
    sha256 cellar: :any,                 arm64_ventura:  "e18f5c2d8ca001c1fbb5c285329e010edf1a15fc487c260260be7a956f5295a8"
    sha256 cellar: :any,                 arm64_monterey: "729aa9b82b21f60f20ddb80a25f6d2c6831ba4efa682412bc46b0bb6a7636090"
    sha256 cellar: :any,                 sonoma:         "c6584ba3540b951e3f47862fcbd72bad173e2f67a6b07f580cdfc1d2f177b950"
    sha256 cellar: :any,                 ventura:        "213edfb1399fa044ae5ba2db68a9d24da0d12ac433634bcf61373337014f7935"
    sha256 cellar: :any,                 monterey:       "f875f123cc9d8ae6c0a06fb741dc2d4ddbfa4894318377a72d64f20b9739b185"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a27250ca0044ab0bc0fb85ddaac7bbc7605c9b3e37d51f1cf200bdee41e1be34"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "pillow"
  depends_on "proj"
  depends_on "python@3.13"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/fc/0f/aafca9af9315aee06a89ffde799a10a582fe8de76c563ee80bbcdc08b3fb/attrs-24.2.0.tar.gz"
    sha256 "5cfb1b9148b5b086569baec03f20d7b6bf3bcacc9a42bebf87ffaaca362f6346"
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

  resource "pyproj" do
    url "https://files.pythonhosted.org/packages/47/c2/0572c8e31aebf0270f15f3368adebd10fc473de9f09567a0743a3bc41c8d/pyproj-3.7.0.tar.gz"
    sha256 "bf658f4aaf815d9d03c8121650b6f0b8067265c36e31bc6660b98ef144d81813"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/99/5b/73ca1f8e72fff6fa52119dbd185f73a907b1989428917b24cff660129b6d/referencing-0.35.1.tar.gz"
    sha256 "25b42124a6c8b632a425174f24087783efb348a6f1e0008e63cd4466fedf703c"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/55/64/b693f262791b818880d17268f3f8181ef799b0d187f6f731b1772e05a29a/rpds_py-0.20.0.tar.gz"
    sha256 "d72a210824facfdaf8768cf2d7ca25a042c30320b3020de2fa04640920d4e121"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/10/27/a33329150147594eff0ea4c33c2036c0eadd933141055be0ff911f7f8d04/Werkzeug-1.0.1.tar.gz"
    sha256 "6c80b1e5ad3665290ea39320b91e1be1e0d5f60652b964a3070216de83d2e47c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"mapproxy-util", "create", "-t", "base-config", testpath
    assert_predicate testpath/"seed.yaml", :exist?
  end
end
