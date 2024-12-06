class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.26.3.tar.gz"
  sha256 "4e7f35861b05cf7f4d4c35a4bbdfebcb6941fcd401d2fc3eeb21f4405da51ada"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+\.\d*[02468]\.\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e189ffe4de75fc30d5212c5eb259ec6f424f1669f15055d00b0b4174c4596082"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "830d63f54cf73e0b9185e854f60220f5defbbcd2a8241f80f372d5e9b5853613"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c26ec8fb30d42901709616c51acae6ea47183497df7e8746703a06e9b3c4b5c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "076d770c3ae79d0e04b8726b6ab6cfbf891d20f5646e025db90ca8d1bbeca222"
    sha256 cellar: :any_skip_relocation, ventura:       "ded3bdfdc8df46342f9a9bc8f2110104ee2bf1eab507fbaf63f0a49648fb9eae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b70603da6f0c31394f265d57e43ebaa8f184f68a39e8611f73335c56cf7c514b"
  end

  depends_on "maven" => :build
  depends_on "openjdk@21"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk@21"].opt_prefix
    system "mvn", "clean", "install", "-DskipTests"

    installer_file = Pathname.glob("installer/target/verapdf-izpack-installer-*.jar").first
    system "java", "-DINSTALL_PATH=#{libexec}", "-jar", installer_file, "-options-system"

    bin.install libexec/"verapdf", libexec/"verapdf-gui"
    bin.env_script_all_files libexec, Language::Java.overridable_java_home_env("21")
    prefix.install "tests"
  end

  test do
    with_env(VERAPDF: bin/"verapdf", NO_CD: "1") do
      system prefix/"tests/exit-status.sh"
    end
  end
end
