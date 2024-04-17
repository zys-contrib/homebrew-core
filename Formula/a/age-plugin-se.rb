class AgePluginSe < Formula
  desc "Age plugin for Apple Secure Enclave"
  homepage "https://github.com/remko/age-plugin-se"
  url "https://github.com/remko/age-plugin-se/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "52d9b9583783988fbe5e94bbe72089a870d128a2eba197fc09a95c13926fb27a"
  license "MIT"
  head "https://github.com/remko/age-plugin-se.git", branch: "main"

  depends_on "scdoc" => :build
  depends_on xcode: ["14.0", :build]
  depends_on "age" => :test
  depends_on :macos
  depends_on macos: :ventura

  def install
    system "make", "PREFIX=#{prefix}", "RELEASE=1", "all"
    system "make", "PREFIX=#{prefix}", "RELEASE=1", "install"
  end

  test do
    (testpath/"secret.txt").write "My secret"
    system "age", "--encrypt",
           "-r", "age1se1qgg72x2qfk9wg3wh0qg9u0v7l5dkq4jx69fv80p6wdus3ftg6flwg5dz2dp",
           "-o", "secret.txt.age", "secret.txt"
    assert_predicate testpath/"secret.txt.age", :exist?

    assert_match version.to_s, shell_output("#{bin}/age-plugin-se --version")
  end
end
