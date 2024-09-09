class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-5.6.2.tgz"
  sha256 "6e954963e7689a13573927021cf1fe2d7f85d7808eba49f03f84cb5d77cdd6bf"
  license "Apache-2.0"
  head "https://github.com/Microsoft/TypeScript.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "822f45e678ec43dbfecc36a60c127f287df0f5d6f53f81095be64d38427bc957"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.ts").write <<~EOS
      class Test {
        greet() {
          return "Hello, world!";
        }
      };
      var test = new Test();
      document.body.innerHTML = test.greet();
    EOS

    system bin/"tsc", "test.ts"
    assert_predicate testpath/"test.js", :exist?, "test.js was not generated"
  end
end
