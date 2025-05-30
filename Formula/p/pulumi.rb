class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.173.0",
      revision: "50cec32d651e73a8f19111281e06825547c109c4"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8025fe212b24b845a87a7bf10559a8c4b1730fd805389f2b6898b7fb9823564d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ce3429f094692b6512fa355ba205eb657435451b8226e5c216684f02e3b0655"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f9c2ac9aa4e8e5a3668a69e104dd2d66b5d8f1193846631afcd408521dc5ef0"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b3b1b2535baee4be198d81add0a35f5e426e7bd68dd18814ec093cd07678c04"
    sha256 cellar: :any_skip_relocation, ventura:       "cf041c416a07c04c0f0f616640da8416ffe6cf8e8731dff24f1699c329777971"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d49da784ddcdf84bb99afca46d8ac3d4fca2715494fa36d1a54d9879c64e41c2"
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
