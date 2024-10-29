class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.16.1.tgz"
  sha256 "cfa797fd010b248c84b0a547c5f43f6d596537f5fa3b5184b3fe8dc27ff13f28"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edeae1602a296301e7dbf6cd22bc4706f3a6b952104f1badf613dcc79fd37eac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edeae1602a296301e7dbf6cd22bc4706f3a6b952104f1badf613dcc79fd37eac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "edeae1602a296301e7dbf6cd22bc4706f3a6b952104f1badf613dcc79fd37eac"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c4a8639159a101f2c77ba94c2c721ddf26f7b9873b906a7c19888b8dab242a9"
    sha256 cellar: :any_skip_relocation, ventura:       "8c4a8639159a101f2c77ba94c2c721ddf26f7b9873b906a7c19888b8dab242a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa1ae6cbe017af1e39d96cae5e17d37d19cda619347daa1325387232e4614c6e"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec/"bin/*"]

    clipboardy_fallbacks_dir = libexec/"lib/node_modules/#{name}/node_modules/clipboardy/fallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    (testpath/"test_cases").write <<~EOS
      GET https://httpbin.org/anything HTTP/1.1
      Content-Type: text/html
      Authorization: Bearer token

      POST https://countries.trevorblades.com/graphql
      Content-Type: application/json

      query Continents($code: String!) {
          continents(filter: {code: {eq: $code}}) {
            code
            name
          }
      }

      {
          "code": "EU"
      }
    EOS

    output = shell_output("#{bin}/httpyac send test_cases --all")
    # for httpbin call
    assert_match "HTTP/1.1 200  - OK", output
    # for graphql call
    assert_match "\"name\": \"Europe\"", output
    assert_match "2 requests processed (2 succeeded)", output

    assert_match version.to_s, shell_output("#{bin}/httpyac --version")
  end
end
