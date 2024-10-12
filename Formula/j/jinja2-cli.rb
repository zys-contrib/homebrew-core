class Jinja2Cli < Formula
  include Language::Python::Virtualenv

  desc "CLI for the Jinja2 templating language"
  homepage "https://github.com/mattrobenolt/jinja2-cli"
  url "https://files.pythonhosted.org/packages/a4/22/c922839761b311b72ccc95c2ca2239311a3e80916458878962626f96922a/jinja2-cli-0.8.2.tar.gz"
  sha256 "a16bb1454111128e206f568c95938cdef5b5a139929378f72bb8cf6179e18e50"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "6953a0e31ca651442a576f2926abc3cbccbaee776fae8c1ce9524f8a5aedae66"
    sha256 cellar: :any,                 arm64_sonoma:   "5a422900be3d065fb5cd68129cd7d702e5399c564759cf21f9bc169223c69cb6"
    sha256 cellar: :any,                 arm64_ventura:  "80dfa76703902486f622b6de9c24e4f28fd1da701c966c2e4034b8b4ed41b7f8"
    sha256 cellar: :any,                 arm64_monterey: "3e5e4715c5c4e8309d65131567f0288cc1e7c3fd9fcda4a290dea8afa00c6ae3"
    sha256 cellar: :any,                 sonoma:         "8722e2649db6798374bfcbb93ad6043fcc53efda58085220ef8293e853762ca9"
    sha256 cellar: :any,                 ventura:        "81cba3a13cd26ab9acb08dd1172ba78486b5c7f9f343f5814305f90f28afa4b3"
    sha256 cellar: :any,                 monterey:       "1bd54d03fb909d3c75370d74fd2cdc5b76c0372b76b1ca5bb02c15d50ac2eed8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f536e019bb6ba1d365c2ce7f2e3ac84c1d2f22065e690fdbd1e8da68387de246"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/ed/55/39036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5d/jinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b4/d2/38ff920762f2247c3af5cbbbbc40756f575d9692d381d7c520f45deb9b8f/markupsafe-3.0.1.tar.gz"
    sha256 "3e683ee4f5d0fa2dde4db77ed8dd8a876686e3fc417655c2ece9a90576905344"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/98/f7/d29b8cdc9d8d075673be0f800013c1161e2fd4234546a140855a1bcc9eb4/xmltodict-0.14.1.tar.gz"
    sha256 "338c8431e4fc554517651972d62f06958718f6262b04316917008e8fd677a6b0"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = if OS.mac?
      shell_output("script -q /dev/null #{bin}/jinja2 --version")
    else
      shell_output("script -q /dev/null -e -c \"#{bin}/jinja2 --version\"")
    end
    assert_match version.to_s, output
    expected_result = <<~EOS
      The Beatles:
      - Ringo Starr
      - George Harrison
      - Paul McCartney
      - John Lennon
    EOS
    template_file = testpath/"my-template.tmpl"
    template_file.write <<~EOS
      {{ band.name }}:
      {% for member in band.members -%}
      - {{ member.first_name }} {{ member.last_name }}
      {% endfor -%}
    EOS
    template_variables_file = testpath/"my-template-variables.json"
    template_variables_file.write <<~EOS
      {
        "band": {
          "name": "The Beatles",
          "members": [
            {"first_name": "Ringo",  "last_name": "Starr"},
            {"first_name": "George", "last_name": "Harrison"},
            {"first_name": "Paul",   "last_name": "McCartney"},
            {"first_name": "John",   "last_name": "Lennon"}
          ]
        }
      }
    EOS
    output = shell_output("#{bin}/jinja2 #{template_file} #{template_variables_file}")
    assert_equal output, expected_result
  end
end
