class NifiRegistry < Formula
  desc "Centralized storage & management of NiFi/MiNiFi shared resources"
  homepage "https://nifi.apache.org/projects/registry"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/2.1.0/nifi-registry-2.1.0-bin.zip"
  mirror "https://archive.apache.org/dist/nifi/2.1.0/nifi-registry-2.1.0-bin.zip"
  sha256 "65b3de00e7448b4c056649465e752f3a74d07e9e6299b6ae1965b2b277f7724f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4c7b3993059e3b4d8a3bec68bf9de55c73e4ae9e2cf53e68f2c39e93b23a8ffc"
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
