class Liquibase < Formula
  desc "Library for database change tracking"
  homepage "https://www.liquibase.org/"
  url "https://github.com/liquibase/liquibase/releases/download/v4.31.1/liquibase-4.31.1.tar.gz"
  sha256 "0555808b59941d497f0c1114c3f2225698afde11c60d191c88e449506a60a3ea"
  license "Apache-2.0"

  livecheck do
    url "https://www.liquibase.com/download"
    regex(/href=.*?liquibase[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df6f2b2fc8d3b627e141125d14d028c7353962108759ddda0abfa52c1a8fe72a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df6f2b2fc8d3b627e141125d14d028c7353962108759ddda0abfa52c1a8fe72a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "df6f2b2fc8d3b627e141125d14d028c7353962108759ddda0abfa52c1a8fe72a"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc43fe10d79006ce9259a3498d6de2deabe61686a79164be9cbbccc592276662"
    sha256 cellar: :any_skip_relocation, ventura:       "bc43fe10d79006ce9259a3498d6de2deabe61686a79164be9cbbccc592276662"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df6f2b2fc8d3b627e141125d14d028c7353962108759ddda0abfa52c1a8fe72a"
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
