class Liquibase < Formula
  desc "Library for database change tracking"
  homepage "https://www.liquibase.org/"
  url "https://github.com/liquibase/liquibase/releases/download/v4.29.2/liquibase-4.29.2.tar.gz"
  sha256 "1d017a206a95ab3076a52f660679c2d80b9f2174942cb0715e35d53931e20ee9"
  license "Apache-2.0"

  livecheck do
    url "https://www.liquibase.com/download"
    regex(/href=.*?liquibase[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0143a2dc142f5056c43fcf50fc4fad305937cba666b60f9aafd049dc10176405"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0143a2dc142f5056c43fcf50fc4fad305937cba666b60f9aafd049dc10176405"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0143a2dc142f5056c43fcf50fc4fad305937cba666b60f9aafd049dc10176405"
    sha256 cellar: :any_skip_relocation, sonoma:         "3920ed53d649d9fbf8ae5e8e7e7066a47277ecb8d7fbd97c5a5f9b88984614b2"
    sha256 cellar: :any_skip_relocation, ventura:        "3920ed53d649d9fbf8ae5e8e7e7066a47277ecb8d7fbd97c5a5f9b88984614b2"
    sha256 cellar: :any_skip_relocation, monterey:       "3920ed53d649d9fbf8ae5e8e7e7066a47277ecb8d7fbd97c5a5f9b88984614b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ef6d22548ccd39b64130785c8b3947a427f6f58badd8f6ca9383aabcdf81ee1"
  end

  depends_on "openjdk"

  def install
    rm(Dir["*.bat"])

    chmod 0755, "liquibase"
    libexec.install Dir["*"]
    (bin/"liquibase").write_env_script libexec/"liquibase", Language::Java.overridable_java_home_env
    (libexec/"lib").install_symlink Dir["#{libexec}/sdk/lib-sdk/slf4j*"]
  end

  def caveats
    <<~EOS
      You should set the environment variable LIQUIBASE_HOME to
        #{opt_libexec}
    EOS
  end

  test do
    system bin/"liquibase", "--version"
  end
end
