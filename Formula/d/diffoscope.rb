class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/51/49/eb7545893027dda1767858b39305c9048a0d9636804616d79a8dc906f2fb/diffoscope-294.tar.gz"
  sha256 "6833785359cade9930fa6d0699f646d62e937bebdb00182e499420f79084cb0d"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75345e8e2520cd505e8deeff49828bbbe0c5830e1ee737fb5f59249f0f547711"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75345e8e2520cd505e8deeff49828bbbe0c5830e1ee737fb5f59249f0f547711"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "75345e8e2520cd505e8deeff49828bbbe0c5830e1ee737fb5f59249f0f547711"
    sha256 cellar: :any_skip_relocation, sonoma:        "fae709eec7ccd30101a71e1e93b4d3ebb16dff784d23b36da1da503759d0a218"
    sha256 cellar: :any_skip_relocation, ventura:       "fae709eec7ccd30101a71e1e93b4d3ebb16dff784d23b36da1da503759d0a218"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b756d617cb981c6a8f1c43090fce21c96e7821fd347a600f3012514927bebfcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b756d617cb981c6a8f1c43090fce21c96e7821fd347a600f3012514927bebfcf"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.13"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/16/0f/861e168fc813c56a78b35f3c30d91c6757d1fd185af1110f1aec784b35d0/argcomplete-3.6.2.tar.gz"
    sha256 "d0519b1bc867f5f4f4713c41ad0aba73a4a5f007449716b16f385f2166dc6adf"
  end

  resource "libarchive-c" do
    url "https://files.pythonhosted.org/packages/bc/0d/c45fe1307564cf550a407fca69cab3969a093d1d41bcd633b278440b4c30/libarchive_c-5.2.tar.gz"
    sha256 "fd44a8e28509af6e78262c98d1a54f306eabd2963dfee57bf298977de5057417"
  end

  resource "progressbar" do
    url "https://files.pythonhosted.org/packages/a3/a6/b8e451f6cff1c99b4747a2f7235aa904d2d49e8e1464e0b798272aa84358/progressbar-2.5.tar.gz"
    sha256 "5d81cb529da2e223b53962afd6c8ca0f05c6670e40309a7219eacc36af9b6c63"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/da/db/0b3e28ac047452d079d375ec6798bf76a036a08182dbb39ed38116a49130/python-magic-0.4.27.tar.gz"
    sha256 "c1ba14b08e4a5f5c31a302b7721239695b2f0f058d125bd5ce1ee36b9d9d3c3b"
  end

  def install
    venv = virtualenv_create(libexec, "python3.13")
    venv.pip_install resources
    venv.pip_install buildpath

    bin.install libexec/"bin/diffoscope"
    libarchive = Formula["libarchive"].opt_lib/shared_library("libarchive")
    bin.env_script_all_files(libexec/"bin", LIBARCHIVE: libarchive)
  end

  test do
    (testpath/"test1").write "test"
    cp testpath/"test1", testpath/"test2"
    system bin/"diffoscope", "--progress", "test1", "test2"
  end
end
