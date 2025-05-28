class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://github.com/planetscale/cli/archive/refs/tags/v0.242.0.tar.gz"
  sha256 "799d677e8211239e80a53ba7bd83be1c3591b9d8a383f552a148d10295b5b6f5"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8e129cb6efdfad2b02d4e52b7d014f61107dd906043298185636391ab9440fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30f78886f9d4b22bc99aefba0cd8d0a5b8522ab69322499f8b233b4b2b849a10"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9661d116902d4cab4bf1c30d0cb5907e2baf3d0e6d6abb5a33940ecd9f3eb2bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f81498f1abe150e0223b9bc6e6d3c7014ecaaaeac64e731e03b4294d9b94d13"
    sha256 cellar: :any_skip_relocation, ventura:       "85c8a991ca4445d2c38efcebfb0bd12a7b52f8d36f8d7ff1773f8eb90083a940"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e6ad699a9f5895f8bc9a9178127de4994165a718022cbc56dffa444a6ad51d6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end
