class NifiRegistry < Formula
  desc "Centralized storage & management of NiFi/MiNiFi shared resources"
  homepage "https://nifi.apache.org/projects/registry"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/1.27.0/nifi-registry-1.27.0-bin.zip"
  mirror "https://archive.apache.org/dist/nifi/1.27.0/nifi-registry-1.27.0-bin.zip"
  sha256 "e2f9e0e952462b466a4a4d217560a3d60646ec2f194761a1a708440d0a94d541"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ae9efc224304b907e2e3c1704ad4b781ce837873777578075caa294ea48c262f"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    rm Dir[libexec/"bin/*.bat"]

    bin.install libexec/"bin/nifi-registry.sh" => "nifi-registry"
    bin.env_script_all_files libexec/"bin/",
                             Language::Java.overridable_java_home_env.merge(NIFI_REGISTRY_HOME: libexec)
  end

  test do
    output = shell_output("#{bin}/nifi-registry status")
    assert_match "Apache NiFi Registry is not running", output
  end
end
