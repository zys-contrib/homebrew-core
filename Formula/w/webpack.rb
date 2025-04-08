require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.99.4.tgz"
  sha256 "e985ef23cda7e361db65fb81aa95f75da604ce7090b1c2ac0068d51c350b5788"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38af6d7262f66cee0623b5367e315e74ae9a7a9f74120c2e25b0d6b3419e5ad1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38af6d7262f66cee0623b5367e315e74ae9a7a9f74120c2e25b0d6b3419e5ad1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "38af6d7262f66cee0623b5367e315e74ae9a7a9f74120c2e25b0d6b3419e5ad1"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8ad40f9b1b3bd7872ae62edd63994159f0acc840ea65d8d69173b89b200a73c"
    sha256 cellar: :any_skip_relocation, ventura:       "f8ad40f9b1b3bd7872ae62edd63994159f0acc840ea65d8d69173b89b200a73c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38af6d7262f66cee0623b5367e315e74ae9a7a9f74120c2e25b0d6b3419e5ad1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38af6d7262f66cee0623b5367e315e74ae9a7a9f74120c2e25b0d6b3419e5ad1"
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
