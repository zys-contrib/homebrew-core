class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.162.0",
      revision: "1f52815bcfe5f1e9307ebe6f342563283f5bc35e"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8a889e254eb886ee1d21a20365e034899b2ec067ed3bb56de419c5c61cb6df1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61ce67f5230d6cfdfb062f86ae5a6cda327c8caf2107754f68456b46d5dfc76e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c85592dec4eab8f92c9b7c77e30168d7dc6e3626b0ee41fb856156db3fb2b747"
    sha256 cellar: :any_skip_relocation, sonoma:        "7545cc0566867aba8dcf796e828b463130ad8b2c2960e82b67fe8be4d4fa577f"
    sha256 cellar: :any_skip_relocation, ventura:       "ce4525ed620ae5afc4075b7b6d4c31d707acda22313f7b1fc5e0740487255a3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d14bd4245bae75ec566f20fb4eba38369c37de331f364f75bdee5c1b33c04dd7"
  end

  depends_on "go" => :build

  def install
    cd "./sdk" do
      system "go", "mod", "download"
    end
    cd "./pkg" do
      system "go", "mod", "download"
    end

    system "make", "brew"

    bin.install Dir["#{ENV["GOPATH"]}/bin/pulumi*"]

    # Install shell completions
    generate_completions_from_executable(bin/"pulumi", "gen-completion")
  end

  test do
    ENV["PULUMI_ACCESS_TOKEN"] = "local://"
    ENV["PULUMI_HOME"] = testpath
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    assert_match "invalid access token",
                 shell_output(bin/"pulumi new aws-typescript --generate-only --force --yes 2>&1", 255)
  end
end
