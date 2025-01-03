class Liquidctl < Formula
  include Language::Python::Virtualenv

  desc "Cross-platform tool and drivers for liquid coolers and other devices"
  homepage "https://github.com/liquidctl/liquidctl"
  url "https://files.pythonhosted.org/packages/d9/86/6c5f842642b88166fb21ab5218a1af47e567f684a564db77eeca2235c7d1/liquidctl-1.14.0.tar.gz"
  sha256 "a90e3f36a13adbaf2f463adf0051f30107fd3d0edecac89f46a5bd931b2b54f2"
  license "GPL-3.0-or-later"
  head "https://github.com/liquidctl/liquidctl.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5b7d116b57b269eadd7006affac38a95761f8b8773aa18877bfb27378bec8467"
    sha256 cellar: :any,                 arm64_sonoma:  "1a4301c9452fbb366a43e086d77bfafb140af1fe4a6256bee0171803cdcf5700"
    sha256 cellar: :any,                 arm64_ventura: "baf3ad92ea880d182f53ee80fd8cabd47a3ba8a4ef6f78557584a3f1eb1cf243"
    sha256 cellar: :any,                 sonoma:        "bf35060fb1ad3e14d28affbb22c42680db0322103944e10f1adb8bde29b19c68"
    sha256 cellar: :any,                 ventura:       "73e72321380e52953bc9d0564a74aeed8f7cc01e589ed4a6b3b613b31d13ce1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "daeeeb0e6b98a1275460bce5cae4994c1c74307c2447dff786da1c744c4d9ce6"
  end

  depends_on "pkgconf" => :build
  depends_on "hidapi"
  depends_on "libusb"
  depends_on "pillow"
  depends_on "python@3.13"

  on_linux do
    depends_on "i2c-tools"
  end

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/d3/7a/359f4d5df2353f26172b3cc39ea32daa39af8de522205f512f458923e677/colorlog-6.9.0.tar.gz"
    sha256 "bfba54a1b93b94f54e1f4fe48395725a3d92fd2a4af702f6bd70946bdc0c6ac2"
  end

  resource "crcmod" do
    url "https://files.pythonhosted.org/packages/6b/b0/e595ce2a2527e169c3bcd6c33d2473c1918e0b7f6826a043ca1245dd4e5b/crcmod-1.7.tar.gz"
    sha256 "dc7051a0db5f2bd48665a990d3ec1cc305a466a77358ca4492826f41f283601e"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "hidapi" do
    url "https://files.pythonhosted.org/packages/47/72/21ccaaca6ffb06f544afd16191425025d831c2a6d318635e9c8854070f2d/hidapi-0.14.0.post4.tar.gz"
    sha256 "48fce253e526d17b663fbf9989c71c7ef7653ced5f4be65f1437c313fb3dbdf6"
  end

  resource "pyusb" do
    url "https://files.pythonhosted.org/packages/e9/63/1dead067e1d6478e1ca6ccf882ade4132f713975739b64cedccf9f33bfc7/pyusb-1.3.0.tar.gz"
    sha256 "7e6de8ef79e164ced020d8131cd17d45a3cdeefb7afdaf41d7a2cbf2378828c3"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/43/54/292f26c208734e9a7f067aea4a7e282c080750c4546559b58e2e45413ca0/setuptools-75.6.0.tar.gz"
    sha256 "8199222558df7c86216af4f84c30e9b34a61d8ba19366cc914424cdbd28252f6"
  end

  def install
    ENV["HIDAPI_SYSTEM_HIDAPI"] = ENV["HIDAPI_WITH_LIBUSB"] = "1"
    virtualenv_install_with_resources

    man_page = buildpath/"liquidctl.8"
    # setting the is_macos register to 1 adjusts the man page for macOS
    inreplace man_page, ".nr is_macos 0", ".nr is_macos 1" if OS.mac?
    man8.install man_page

    (lib/"udev/rules.d").install Dir["extra/linux/*.rules"] if OS.linux?
  end

  test do
    system bin/"liquidctl", "list", "--verbose", "--debug"
  end
end
