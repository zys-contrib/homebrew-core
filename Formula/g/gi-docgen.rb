class GiDocgen < Formula
  include Language::Python::Virtualenv

  desc "Documentation tool for GObject-based libraries"
  homepage "https://gnome.pages.gitlab.gnome.org/gi-docgen/"
  url "https://files.pythonhosted.org/packages/55/e1/c32a1ee817fc7d11462b4ed8722b049c70dd61ce0b236f74e7cf4262412e/gi_docgen-2025.3.tar.gz"
  sha256 "2fdb4f0f6b61184ab862fcfb41dafe1a795636de9fd8d21a8ca4feea3b6bf858"
  license any_of: ["Apache-2.0", "GPL-3.0-or-later"]
  head "https://gitlab.gnome.org/GNOME/gi-docgen.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efb6000d36c8b1d943c9168de1e24f786cea02c666ae6ce217569bbe5cd71d97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "461500915dfbb1790cd88991c34a6b2eb74825bc4ccf8334ee00b885a583d7fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "57d9467b5ebbc3635d1a74e8492a7aa890f6149ab32d49328254bdadf458304b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba5cd04c92b601181e5423e558f711a6125869ebf1feb79d5340c83ad63d0026"
    sha256 cellar: :any_skip_relocation, ventura:       "68f3b5360ae636a399e0874fcca8e0fff433bcc38b9a0bb230f3baa7c7e47e82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cee5988c247f1e42d7cd84da6e053af9735ad303dab31a0831cfa49be99836e3"
  end

  depends_on "python@3.13"

  # Source for latest version is not available on PyPI, so using GitHub tarball instead.
  # Issue ref: https://github.com/leohemsted/smartypants.py/issues/8
  resource "smartypants" do
    url "https://github.com/leohemsted/smartypants.py/archive/refs/tags/v2.0.1.tar.gz"
    sha256 "b98191911ff3b4144ef8ad53e776a2d0ad24bd508a905c6ce523597c40022773"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/af/92/b3130cbbf5591acf9ade8708c365f3238046ac7cb8ccba6e81abccb0ccff/jinja2-3.1.5.tar.gz"
    sha256 "8fefff8dc3034e27bb80d67c671eb8a9bc424c0ef4c0826edbff304cceff43bb"
  end

  resource "markdown" do
    url "https://files.pythonhosted.org/packages/54/28/3af612670f82f4c056911fbbbb42760255801b3068c48de792d354ff4472/markdown-3.7.tar.gz"
    sha256 "2ae2471477cfd02dbbf038d5d9bc226d40def84b4fe2986e49b59b6b472bbed2"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/7c/2d/c3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84/pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "typogrify" do
    url "https://files.pythonhosted.org/packages/93/8c/b73fe0050bbf67c172b7c6d0c74c356939de0e891e669667f20381c099a8/typogrify-2.1.0.tar.gz"
    sha256 "f0aa004e98032a6e6be4c9da65e7eb7150e36ca3bf508adbcda82b4d003e61ee"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"brew.toml").write <<~TOML
      [library]
      description = "Homebrew gi-docgen formula test"
      authors = "Homebrew"
      license = "BSD-2-Clause"
      browse_url = "https://github.com/Homebrew/brew"
      repository_url = "https://github.com/Homebrew/brew.git"
      website_url = "https://brew.sh/"
    TOML

    (testpath/"brew.gir").write <<~EOS
      <?xml version="1.0"?>
      <repository version="1.2"
                  xmlns="http://www.gtk.org/introspection/core/1.0"
                  xmlns:c="http://www.gtk.org/introspection/c/1.0">
        <namespace name="brew" version="1.0" c:identifier-prefixes="brew" c:symbol-prefixes="brew">
          <record name="Formula" c:type="Formula">
            <field name="name" writable="1">
              <type name="utf8" c:type="char*"/>
            </field>
          </record>
        </namespace>
      </repository>
    EOS

    output = shell_output("#{bin}/gi-docgen generate -C brew.toml brew.gir")
    assert_match "Creating namespace index file for brew-1.0", output
    assert_path_exists testpath/"brew-1.0/index.html"
    assert_path_exists testpath/"brew-1.0/struct.Formula.html"
    assert_match %r{Website.*>https://brew.sh/}, (testpath/"brew-1.0/index.html").read
    assert_match(/struct.*Formula.*{/, (testpath/"brew-1.0/struct.Formula.html").read)
  end
end
