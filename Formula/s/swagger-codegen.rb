class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/tools/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/refs/tags/v3.0.70.tar.gz"
  sha256 "d7e13130abe3405d847a2cdb6f2a67d4bef6c157f159b9da1aefbc988d523319"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcae575890a52edf9ea29199558dbc51ebbb3a4daca69121364b561d76153e78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6e6bc84d97c4364689689da1d11cc0c5b1876272c20baa9fa893ba9938d5e08"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5bf6233172f6c672a5f1188b825a005d73d33f25868b4c456952d5a330e1b830"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4c4bc297e6404719495baa7302dfde7739274dd62c9238562258d59a0f6e8c8"
    sha256 cellar: :any_skip_relocation, ventura:       "fb340797bc5539dceec003b2d64d7c28720f77883f97142a05d2287bd52efb9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a469dfc63e8c239cdb4be7aea11973b510b56cb865ca662ea26a42432927165f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d48f8c2c0026cb0bb96aa6f2a37258d350e3f4d47232a0aefe21b32638bf4c10"
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  # patch swagger-codegen-generators version, upstream issue, https://github.com/swagger-api/swagger-codegen/issues/12573
  patch :DATA

  def install
    # Need to set JAVA_HOME manually since maven overrides 1.8 with 1.7+
    ENV["JAVA_HOME"] = Language::Java.java_home

    system "mvn", "clean", "package"
    libexec.install "modules/swagger-codegen-cli/target/swagger-codegen-cli.jar"
    bin.write_jar_script libexec/"swagger-codegen-cli.jar", "swagger-codegen"
  end

  test do
    (testpath/"minimal.yaml").write <<~YAML
      ---
      openapi: 3.0.0
      info:
        version: 0.0.0
        title: Simple API
      paths:
        /:
          get:
            responses:
              200:
                description: OK
    YAML
    system bin/"swagger-codegen", "generate", "-i", "minimal.yaml", "-l", "html"
    assert_includes File.read(testpath/"index.html"), "<h1>Simple API</h1>"
  end
end

__END__
diff --git a/pom.docker.xml b/pom.docker.xml
index f893961..aa9fbf6 100644
--- a/pom.docker.xml
+++ b/pom.docker.xml
@@ -1107,7 +1107,7 @@
     </dependencyManagement>
     <properties>
         <maven.compiler.release>8</maven.compiler.release>
-        <swagger-codegen-generators-version>1.0.58-SNAPSHOT</swagger-codegen-generators-version>
+        <swagger-codegen-generators-version>1.0.57</swagger-codegen-generators-version>
         <swagger-core-version>2.2.28</swagger-core-version>
         <swagger-core-version-v1>1.6.15</swagger-core-version-v1>
         <swagger-parser-version>2.1.25</swagger-parser-version>
diff --git a/pom.xml b/pom.xml
index b46c57d..6690405 100644
--- a/pom.xml
+++ b/pom.xml
@@ -1208,7 +1208,7 @@
     </dependencyManagement>
     <properties>
         <maven.compiler.release>8</maven.compiler.release>
-        <swagger-codegen-generators-version>1.0.58-SNAPSHOT</swagger-codegen-generators-version>
+        <swagger-codegen-generators-version>1.0.57</swagger-codegen-generators-version>
         <swagger-core-version>2.2.28</swagger-core-version>
         <swagger-core-version-v1>1.6.15</swagger-core-version-v1>
         <swagger-parser-version>2.1.25</swagger-parser-version>
diff --git a/samples/meta-codegen/pom.xml b/samples/meta-codegen/pom.xml
index a0074a4..480530c 100644
--- a/samples/meta-codegen/pom.xml
+++ b/samples/meta-codegen/pom.xml
@@ -121,7 +121,7 @@
     <properties>
         <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
         <swagger-codegen-version>3.0.70</swagger-codegen-version>
-        <swagger-codegen-generators-version>1.0.58-SNAPSHOT</swagger-codegen-generators-version>
+        <swagger-codegen-generators-version>1.0.57</swagger-codegen-generators-version>
         <maven-plugin-version>1.0.0</maven-plugin-version>
         <junit-version>4.13.2</junit-version>
         <build-helper-maven-plugin>3.0.0</build-helper-maven-plugin>
