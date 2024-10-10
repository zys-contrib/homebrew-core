class Remarshal < Formula
  include Language::Python::Virtualenv

  desc "Convert between TOML, YAML and JSON"
  homepage "https://github.com/remarshal-project/remarshal"
  url "https://files.pythonhosted.org/packages/ae/e7/98e22a9d62ee2c086da94f6aafeee5e7c3a68197d761cc22c90e7e949afb/remarshal-0.18.0.tar.gz"
  sha256 "8fd29ba9d5931f5ee2c54f902b11b26cd3bbca0ad8b3d6f39ca48255284f71dd"
  license "MIT"
  head "https://github.com/remarshal-project/remarshal.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "dd3fb4496ecf2971c7c13af97f6b7666682dd4ad596447761596ad5f33b1851d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af300c5d2b86f9e76229391e05a6f01f333cf0395c7e9cc1b320fb1a7dd4214a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9aeb55805a5b89c669d3a25a37ebee48102e7047ab4ac14252a95222cda4fb7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a21e31c47836f2caa2fcf6633f7bc3282e16ee5d1e668309568f0a1cfafb9d88"
    sha256 cellar: :any_skip_relocation, sonoma:         "5ea31762175be7227b537cc4292d96b0c094cf5faf9eaef869ca4515bc5417b9"
    sha256 cellar: :any_skip_relocation, ventura:        "f902f738e9ce8d2aee070f28ecfdfba70cd3aaa651af8f02b5299f6dd3c6a9fb"
    sha256 cellar: :any_skip_relocation, monterey:       "25ff35a23aa5f42608d28d2f6998ab0851a48d6bf2f72d5b489b9027a93f67c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e7130beb623155ecbb6bcb9fa7ad5bc799e44f85956f5ba30053a0e1e629c07"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  conflicts_with "msgpack-tools", because: "both install 'json2msgpack' binary"

  resource "cbor2" do
    url "https://files.pythonhosted.org/packages/e4/aa/ba55b47d51d27911981a18743b4d3cebfabccbb0598c09801b734cec4184/cbor2-5.6.5.tar.gz"
    sha256 "b682820677ee1dbba45f7da11898d2720f92e06be36acec290867d5ebf3d7e09"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/aa/9e/1784d15b057b0075e5136445aaea92d23955aad2c93eaede673718a40d95/rich-13.9.2.tar.gz"
    sha256 "51a2c62057461aaf7152b4d611168f93a9fc73068f8ded2790f29fe2b5366d0c"
  end

  resource "rich-argparse" do
    url "https://files.pythonhosted.org/packages/26/f1/0a5ba24d684012e2f25deec88d9a9a1199d8e26e3bb595b812c8b0218cff/rich_argparse-1.5.2.tar.gz"
    sha256 "84d348d5b6dafe99fffe2c7ea1ca0afe14096c921693445b9eee65ee4fcbfd2c"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/29/81/4dfc17eb6ebb1aac314a3eb863c1325b907863a1b8b1382cdffcb6ac0ed9/ruamel.yaml-0.18.6.tar.gz"
    sha256 "8b27e6a217e786c6fbe5634d8f3f11bc63e0f80f6a5890f28863d9c45aac311b"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/2b/ab/18f4c8f2bec75eb1a7aebcc52cdb02ab04fd39ff7025bb1b1c7846cc45b8/tomlkit-0.12.5.tar.gz"
    sha256 "eef34fba39834d4d6b73c9ba7f3e4d1c417a4e56f89a7e96e090dd0d24b8fb3c"
  end

  resource "u-msgpack-python" do
    url "https://files.pythonhosted.org/packages/36/9d/a40411a475e7d4838994b7f6bcc6bfca9acc5b119ce3a7503608c4428b49/u-msgpack-python-2.8.0.tar.gz"
    sha256 "b801a83d6ed75e6df41e44518b4f2a9c221dc2da4bcd5380e3a0feda520bc61a"
  end

  def install
    # Work around ruamel.yaml.clib not building on Xcode 15.3, remove after a new release
    # has resolved: https://sourceforge.net/p/ruamel-yaml-clib/tickets/32/
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    virtualenv_install_with_resources
  end

  test do
    json = "{\"foo.bar\":\"baz\",\"qux\":1}"
    yaml = <<~EOS.chomp
      foo.bar: baz
      qux: 1

    EOS
    toml = <<~EOS.chomp
      "foo.bar" = "baz"
      qux = 1

    EOS
    assert_equal yaml, pipe_output("#{bin}/remarshal -if=json -of=yaml", json)
    assert_equal yaml, pipe_output("#{bin}/json2yaml", json)
    assert_equal toml, pipe_output("#{bin}/remarshal -if=yaml -of=toml", yaml)
    assert_equal toml, pipe_output("#{bin}/yaml2toml", yaml)
    assert_equal json, pipe_output("#{bin}/remarshal -if=toml -of=json", toml).chomp
    assert_equal json, pipe_output("#{bin}/toml2json", toml).chomp
    assert_equal pipe_output("#{bin}/remarshal -if=yaml -of=msgpack", yaml),
      pipe_output("#{bin}/remarshal -if=json -of=msgpack", json)

    assert_match version.to_s, shell_output("#{bin}/remarshal --version")
  end
end
