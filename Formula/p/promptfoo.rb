class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.84.1.tgz"
  sha256 "1b855b007673cf84246c8222cffe84b1e229af4d73c528a97756d78f6ff531a3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6e8ad503eae0705ee157cdd7a3b67dbd71d7d54d631c7a496088b9e80db0bf1e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e63dbaaae9f51dc0167e162284710a9ee8f4dacf6947cf35c7af8782d271cac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3400d4da32bff362d118b088e683e4fbb3efc91f899b9b70285725d36742aa72"
    sha256 cellar: :any_skip_relocation, sonoma:         "a8762d0ff41acbf6b6cac3ab5730b5a346beeeb465da32f211d77428d7566213"
    sha256 cellar: :any_skip_relocation, ventura:        "c45bc33a7fa5116849acd561864749ce5093d9143843d144b6a069f199c589ab"
    sha256 cellar: :any_skip_relocation, monterey:       "8179c1df7e9f69b4449c2214f003cf9894570882c6847f8621e7fe65ae15fcff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfb019147d723e45d29620db8143eb7980da78b87324528aa6c847972f6c5267"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_predicate testpath/"promptfooconfig.yaml", :exist?
    assert_match "description: \"My eval\"", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end
