require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.99.0.tgz"
  sha256 "21a5c68193435da6df8ac7dabf7419ed3efb193b0134cadb5450434c0dd860a5"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2df25017889786ca752535578e0ad2b7befa75fc3ef2fff35774da7b0ac6fd1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2df25017889786ca752535578e0ad2b7befa75fc3ef2fff35774da7b0ac6fd1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e2df25017889786ca752535578e0ad2b7befa75fc3ef2fff35774da7b0ac6fd1"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9c26f232c4432f7a9a1c1096b004de55d28847a7ff3bf234da7fccc9024dd1f"
    sha256 cellar: :any_skip_relocation, ventura:       "a9c26f232c4432f7a9a1c1096b004de55d28847a7ff3bf234da7fccc9024dd1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2df25017889786ca752535578e0ad2b7befa75fc3ef2fff35774da7b0ac6fd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2df25017889786ca752535578e0ad2b7befa75fc3ef2fff35774da7b0ac6fd1"
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-6.0.1.tgz"
    sha256 "f407788079854b0d48fb750da496c59cf00762dce3731520a4b375a377dec183"
  end

  def install
    (buildpath/"node_modules/webpack").install Dir["*"]
    buildpath.install resource("webpack-cli")

    cd buildpath/"node_modules/webpack" do
      system "npm", "install", *std_npm_args(prefix: false), "--force"
    end

    # declare webpack as a bundledDependency of webpack-cli
    pkg_json = JSON.parse(File.read("package.json"))
    pkg_json["dependencies"]["webpack"] = version
    pkg_json["bundleDependencies"] = ["webpack"]
    File.write("package.json", JSON.pretty_generate(pkg_json))

    system "npm", "install", *std_npm_args

    bin.install_symlink libexec.glob("bin/*")
    bin.install_symlink libexec/"bin/webpack-cli" => "webpack"
  end

  test do
    (testpath/"index.js").write <<~JS
      function component() {
        const element = document.createElement('div');
        element.innerHTML = 'Hello webpack';
        return element;
      }

      document.body.appendChild(component());
    JS

    system bin/"webpack", "bundle", "--mode=production", testpath/"index.js"
    assert_match 'const e=document.createElement("div");', (testpath/"dist/main.js").read
  end
end
