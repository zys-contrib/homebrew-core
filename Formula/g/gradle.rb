class Gradle < Formula
  desc "Open-source build automation tool based on the Groovy and Kotlin DSL"
  homepage "https://www.gradle.org/"
  url "https://services.gradle.org/distributions/gradle-8.10-all.zip"
  sha256 "682b4df7fe5accdca84a4d1ef6a3a6ab096b3efd5edf7de2bd8c758d95a93703"
  license "Apache-2.0"

  livecheck do
    url "https://gradle.org/install/"
    regex(/href=.*?gradle[._-]v?(\d+(?:\.\d+)+)-all\.(?:zip|t)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f78128a5cdaa11381e561e1bf5fd8f04cd8fd238991d70d553d5cf8ad1cec211"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f78128a5cdaa11381e561e1bf5fd8f04cd8fd238991d70d553d5cf8ad1cec211"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f78128a5cdaa11381e561e1bf5fd8f04cd8fd238991d70d553d5cf8ad1cec211"
    sha256 cellar: :any_skip_relocation, sonoma:         "4dd21d10e34f21932d5b14807923231000d1d7057465b0fc7573ec9c65039ab3"
    sha256 cellar: :any_skip_relocation, ventura:        "4dd21d10e34f21932d5b14807923231000d1d7057465b0fc7573ec9c65039ab3"
    sha256 cellar: :any_skip_relocation, monterey:       "4dd21d10e34f21932d5b14807923231000d1d7057465b0fc7573ec9c65039ab3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb55499539a68e56ce0de580deed54841832109784eeed6298ef63f65b048479"
  end

  # https://github.com/gradle/gradle/blob/master/platforms/documentation/docs/src/docs/userguide/releases/compatibility.adoc
  depends_on "openjdk"

  def install
    rm(Dir["bin/*.bat"])
    libexec.install %w[bin docs lib src]
    env = Language::Java.overridable_java_home_env
    (bin/"gradle").write_env_script libexec/"bin/gradle", env
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gradle --version")

    (testpath/"settings.gradle").write ""
    (testpath/"build.gradle").write <<~EOS
      println "gradle works!"
    EOS
    gradle_output = shell_output("#{bin}/gradle build --no-daemon")
    assert_includes gradle_output, "gradle works!"
  end
end
