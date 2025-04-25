class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https://nixpacks.com/docs/getting-started"
  url "https://github.com/railwayapp/nixpacks/archive/refs/tags/v1.37.0.tar.gz"
  sha256 "30875dccc05532feadb303ce7ed62a6c60edeec8f845d9dfbbb28fd0999acdf4"
  license "MIT"
  head "https://github.com/railwayapp/nixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c1f216a1d371d54f077c497c7803bc21145df862ef1c65dea8f8447bdc92f79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71a0b0d60a6d8e40ec7d6603d17e39d232eedcc7e50b1dacf1b25af31723f8c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "edab9e7060562b1187af92337be412526c96ac1a58a410df67e1e36af939aeeb"
    sha256 cellar: :any_skip_relocation, sonoma:        "6cdc0d8646011184c5b91690e525a099ab8e5fc8e0c699d15432a3974621743f"
    sha256 cellar: :any_skip_relocation, ventura:       "6069ee1edff01d2e1ef71da03b935ad29a5e99fb9db28c2424e364d7ea610cf5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fe993fadf3751368bf2e4d7fcb86a5b3a68843ae339d334beff06c621ec653c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f261ae471e30adde5491cd14a2c070324021f556f55bb794a8a1885d89fb843"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/nixpacks build #{testpath} --name test", 1)
    assert_match "Nixpacks was unable to generate a build plan for this app", output

    assert_equal "nixpacks #{version}", shell_output("#{bin}/nixpacks -V").chomp
  end
end
