class Nexus < Formula
  desc "Repository manager for binary software components"
  homepage "https://www.sonatype.com/"
  url "https://github.com/sonatype/nexus-public/archive/refs/tags/release-3.76.1-01.tar.gz"
  sha256 "e2fe13994f4ffcc3e5389ea90e14a1dcc7af92ce37015a961f89bbf151d29c86"
  license "EPL-1.0"

  # As of writing, upstream is publishing both v2 and v3 releases. The "latest"
  # release on GitHub isn't reliable, as it can point to a release from either
  # one of these major versions depending on which was published most recently.
  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(\d+(?:[.-]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, sonoma:       "1ef405d468f02b4d97e3e61d83d36341e7550642ac097bdfba458f515ad04e78"
    sha256 cellar: :any_skip_relocation, ventura:      "9114db0415c4582f0d1e97e8d7cb8758a1bd2d8094222eae33119f189a3dc85d"
    sha256 cellar: :any_skip_relocation, monterey:     "2d4e904050b210d103b36b47aaed37dcef075aa24b3713d54f040203308cf0e3"
    sha256 cellar: :any_skip_relocation, big_sur:      "ebcc0f030b0c84158344636dc0884d511ad386df587d92725f251725066c7151"
    sha256 cellar: :any_skip_relocation, catalina:     "abc68c0f85091cfd502bf0d4d8b87be1281e63a2350dcaf24b4a407317b14d35"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "dcbe0eea411e6b44a8a86d0ee9ede0b8a1ba15aaeef69cecfb0185b9629f1ac6"
  end

  depends_on "maven" => :build
  depends_on "openjdk@17"

  uses_from_macos "unzip" => :build

  on_macos do
    depends_on arch: :x86_64 # due to node binary fetched by frontend-maven-plugin
  end

  def install
    # Workaround build error: Couldn't find package "@sonatype/nexus-ui-plugin@workspace:*"
    # Ref: https://github.com/sonatype/nexus-public/issues/417
    # Ref: https://github.com/sonatype/nexus-public/issues/432#issuecomment-2663250153
    inreplace ["components/nexus-rapture/package.json", "plugins/nexus-coreui-plugin/package.json"],
              '"@sonatype/nexus-ui-plugin": "workspace:*"',
              '"@sonatype/nexus-ui-plugin": "*"'

    ENV["JAVA_HOME"] = Language::Java.java_home("17")
    system "mvn", "install", "-DskipTests", "-Dpublic"
    system "unzip", "-o", "-d", "target", "assemblies/nexus-base-template/target/nexus-base-template-#{version}.zip"

    rm(Dir["target/nexus-base-template-#{version}/bin/*.bat"])
    rm_r("target/nexus-base-template-#{version}/bin/contrib")
    libexec.install Dir["target/nexus-base-template-#{version}/*"]

    env = {
      JAVA_HOME:  ENV["JAVA_HOME"],
      KARAF_DATA: "${NEXUS_KARAF_DATA:-#{var}/nexus}",
      KARAF_LOG:  "#{var}/log/nexus",
      KARAF_ETC:  "#{etc}/nexus",
    }

    (bin/"nexus").write_env_script libexec/"bin/nexus", env
  end

  def post_install
    mkdir_p "#{var}/log/nexus" unless (var/"log/nexus").exist?
    mkdir_p "#{var}/nexus" unless (var/"nexus").exist?
    mkdir "#{etc}/nexus" unless (etc/"nexus").exist?
  end

  service do
    run [opt_bin/"nexus", "start"]
  end

  test do
    mkdir "data"
    fork do
      ENV["NEXUS_KARAF_DATA"] = testpath/"data"
      exec bin/"nexus", "server"
    end
    sleep 50
    sleep 50 if OS.mac? && Hardware::CPU.intel?
    assert_match "<title>Sonatype Nexus Repository</title>", shell_output("curl --silent --fail http://localhost:8081")
  end
end
