class CypherShell < Formula
  desc "Command-line shell where you can execute Cypher against Neo4j"
  homepage "https://neo4j.com"
  url "https://dist.neo4j.org/cypher-shell/cypher-shell-5.21.0.zip"
  sha256 "98120a168bf67c6040429d0abab44371c588577680508edcd741a70c2ceca8a6"
  license "GPL-3.0-only"
  revision 1
  version_scheme 1

  livecheck do
    url "https://neo4j.com/deployment-center/"
    regex(/href=.*?cypher-shell[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5707effb6d5ad2233f912ed7220c37e07219cfdd5122ef85ebc350cb28beba52"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5707effb6d5ad2233f912ed7220c37e07219cfdd5122ef85ebc350cb28beba52"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5707effb6d5ad2233f912ed7220c37e07219cfdd5122ef85ebc350cb28beba52"
    sha256 cellar: :any_skip_relocation, sonoma:         "5707effb6d5ad2233f912ed7220c37e07219cfdd5122ef85ebc350cb28beba52"
    sha256 cellar: :any_skip_relocation, ventura:        "5707effb6d5ad2233f912ed7220c37e07219cfdd5122ef85ebc350cb28beba52"
    sha256 cellar: :any_skip_relocation, monterey:       "5707effb6d5ad2233f912ed7220c37e07219cfdd5122ef85ebc350cb28beba52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82984c4e4e34e0c098f7cf57951f795cf8cbb9da2bf586ca95b9e97ab0711819"
  end

  depends_on "openjdk@21"

  conflicts_with "neo4j", because: "both install `cypher-shell` binaries"

  def install
    libexec.install Dir["*"]
    (bin/"cypher-shell").write_env_script libexec/"bin/cypher-shell", Language::Java.overridable_java_home_env("21")
  end

  test do
    refute_match "unsupported version of the Java runtime", shell_output("#{bin}/cypher-shell -h 2>&1", 1)
    # The connection will fail and print the name of the host
    assert_match "doesntexist", shell_output("#{bin}/cypher-shell -a bolt://doesntexist 2>&1", 1)
  end
end
