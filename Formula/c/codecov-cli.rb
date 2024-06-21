class CodecovCli < Formula
  include Language::Python::Virtualenv

  desc "Codecov's command-line interface"
  homepage "https://cli.codecov.io/"
  url "https://files.pythonhosted.org/packages/63/4f/7a503044f27bb2c414c7be1cde73525bcea5af23de1ccdf8bfa73a4da328/codecov-cli-0.7.0.tar.gz"
  sha256 "4c3cd8a552dc5a1663cd3b08b9d6a7bc759e81fead77320e87cb1c7984e991c9"
  license "Apache-2.0"
  head "https://github.com/codecov/codecov-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e15a90e366398b49ee50fc9545d3a6e1abcbb8c6d4e72040b876223642156752"
    sha256 cellar: :any,                 arm64_ventura:  "95a78f2895413864b8a5abbe2a3f5c11819c749ae3e97cd314619f50fb11e7d8"
    sha256 cellar: :any,                 arm64_monterey: "c94fde3bf5c3f9c0d2f5889547bb485ba87926dacfde8eb306c20cb7689af2f5"
    sha256 cellar: :any,                 sonoma:         "1d4207130e164fbc6c00c4c33921bbeb6d0297ea8c4c617409d4646976f2e658"
    sha256 cellar: :any,                 ventura:        "79bb2fd19994f66deea9324c729dcbb2c426a18a1363e0343d4b6c4299a8c3fb"
    sha256 cellar: :any,                 monterey:       "dd94fd78c83289613d4d50df1ac6bd717d397f875b75a2d154d7089fea717c75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a60f4639456481982507ccbcc766aabcca922f8548237c666b6414e7e05ac245"
  end

  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/e6/e3/c4c8d473d6780ef1853d630d581f70d655b4f8d7553c6997958c283039a2/anyio-4.4.0.tar.gz"
    sha256 "5aadc6a1bbb7cdb0bede386cac5e2940f5e2ff3aa20277e991cf028e0585ce94"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/07/b3/e02f4f397c81077ffc52a538e0aec464016f1860c472ed33bd2a1d220cc5/certifi-2024.6.2.tar.gz"
    sha256 "3cd43f1c6fa7dedc5899d69d3ad0398fd018ad1a17fba83ddaf78aa46c747516"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/f5/38/3af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03/h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/61/42/5c456b02816845d163fab0f32936b6a5b649f3f915beff6f819f4f6c90b2/httpcore-0.16.3.tar.gz"
    sha256 "c5d6f04e2fc530f39e0c077e6a30caa53f1451096120f1f38b954afd0b17c0cb"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/f5/50/04d5e8ee398a10c767a341a25f59ff8711ae3adf0143c7f8b45fc560d72d/httpx-0.23.3.tar.gz"
    sha256 "9818458eb565bb54898ccb9b8b251a28785dd4a55afbc23d0eb410754fe7d0f9"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "ijson" do
    url "https://files.pythonhosted.org/packages/6c/83/28e9e93a3a61913e334e3a2e78ea9924bb9f9b1ac45898977f9d9dd6133f/ijson-3.3.0.tar.gz"
    sha256 "7f172e6ba1bee0d4c8f8ebd639577bfe429dee0f3f96775a067b8bae4492d8a0"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/7a/db/5ddc89851e9cc003929c3b08b9b88b429459bf9acbf307b4556d51d9e49b/regex-2024.5.15.tar.gz"
    sha256 "d3ee02d9e5f482cc8309134a91eeaacbdd2261ba111b0fef3748eeb4913e6a2c"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "responses" do
    url "https://files.pythonhosted.org/packages/6d/db/b949a6bf2a75c64caea0a6b39d05e433aa2e51bea78ae9d5dda1110b31a5/responses-0.21.0.tar.gz"
    sha256 "b82502eb5f09a0289d8e209e7bad71ef3978334f56d09b444253d5ad67bf5253"
  end

  resource "rfc3986" do
    url "https://files.pythonhosted.org/packages/79/30/5b1b6c28c105629cc12b33bdcbb0b11b5bb1880c6cfbd955f9e792921aa8/rfc3986-1.5.0.tar.gz"
    sha256 "270aaf10d87d0d4e095063c65bf3ddbc6ee3d0b226328ce21e036f946e421835"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/1c/1c/8a56622f2fc9ebb0df743373ef1a96c8e20410350d12f44ef03c588318c3/setuptools-70.1.0.tar.gz"
    sha256 "01a1e793faa5bd89abc851fa15d0a0db26f160890c7102cd8dce643e886b47f5"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "test-results-parser" do
    url "https://files.pythonhosted.org/packages/fa/1f/35f5b23beb148c36285bfe9722adeaef976814670ebf9bd8129356a283c8/test_results_parser-0.1.0.tar.gz"
    sha256 "0034281a4b406d7f072fc5ac1f5e44660e3c23bc92f2e7284862ee097f9626ee"
  end

  resource "tree-sitter" do
    url "https://files.pythonhosted.org/packages/4a/64/71b3a0ff7d0d89cb333caeca01992099c165bdd663e7990ea723615e60f4/tree_sitter-0.20.4.tar.gz"
    sha256 "6adb123e2f3e56399bbf2359924633c882cc40ee8344885200bca0922f713be5"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/43/6d/fa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6/urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "codecovcli, version #{version}\n", shell_output("#{bin}/codecovcli --version")

    # Unfortunately `shell_output` doesn't capture standard error
    output = shell_output(["#{bin}/codecovcli create-report --commit-sha #{SecureRandom.hex(40)}",
                           "--slug test/repo --token #{SecureRandom.hex(10)} 2>&1"].join(" "))

    ["No config file could be found. Ignoring config.",
     "Process Report creating complete",
     "Report creating failed: {\"detail\":\"Not valid tokenless upload\"}"].each do |l|
       assert_match l, output
     end
  end
end
