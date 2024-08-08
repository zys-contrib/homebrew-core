class Mdless < Formula
  desc "Provides a formatted and highlighted view of Markdown files in Terminal"
  homepage "https://github.com/ttscoff/mdless"
  url "https://github.com/ttscoff/mdless/archive/refs/tags/2.1.44.tar.gz"
  sha256 "baa3df2a641f5f8646c90d955a1a89cee1e21aa3a571cbcbe6b45ee0df3189ea"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d14c17776340e20d3330fce4796de5e6b6384b22cc8ad28356415963dcd51fbc"
    sha256 cellar: :any,                 arm64_ventura:  "f5e252648296e3fddfefbcf5f96429cbe432fdcafc359180892214018a199599"
    sha256 cellar: :any,                 arm64_monterey: "d887fc81b7698332aa0961c95f581d85af459710f73492f8413e2eed4965bff2"
    sha256 cellar: :any,                 sonoma:         "1d676b07d0e2b4bc1411afd96b55951f7d7e2025711cf5b7acc165bb7dab37ef"
    sha256 cellar: :any,                 ventura:        "2785dbbb55f4e8457626d036eadb751e991a7212c8653a8350ac5604782f373d"
    sha256 cellar: :any,                 monterey:       "9a9e54d2d9778078b3a972589a52e7fa0ea20639a7e7a3261f8b5ef20d774afd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fb577102a312827d1615615255a0c55b9c86a5a3b1cd5dc646de396f496f09f"
  end

  # Requires Ruby >= 2.7
  depends_on "ruby"

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"
    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_match "mdless #{version}", shell_output("#{bin}/mdless --version")
    (testpath/"test.md").write <<~EOS
      # title first level
      ## title second level
    EOS
    out = shell_output("#{bin}/mdless --no-color -P test.md")
    assert_match(/^title first level =+$/, out)
    assert_match(/^title second level -+$/, out)
  end
end
