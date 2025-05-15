class Risor < Formula
  desc "Fast and flexible scripting for Go developers and DevOps"
  homepage "https://risor.io/"
  url "https://github.com/risor-io/risor/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "3253a3e6e6f2916f0fe5f415e170c84e7bfede59e66d45d036d1018c259cba91"
  license "Apache-2.0"
  head "https://github.com/risor-io/risor.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "474c2c3bcae77609be0ca9a906ae08d2c7e310a1ca88f24b1c59c42a94bd020c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eec23fd33f6539d48eebcee3b86817c3f1aea6c61f41f038b17894cde7c7cfe6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e8a79031895806c2caf32e5a67f776bfe4c29b9c0b30360e5c67f0973ccadf80"
    sha256 cellar: :any_skip_relocation, sonoma:        "53ed559df44d5be6004fce9754170e6a3c69999da22ec65c3a5a200a4507e43c"
    sha256 cellar: :any_skip_relocation, ventura:       "73722107f1a1c08135f8f94337bdd350d7703759b102bab87cf48acf130e371b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47c688c93ef50a84d9c53e799337ccbcb88924d56679623a3909bc399d39b3b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c17f69f98dc9b78bacb5f693a48251e6b6bc9ef2c7eb4b75bc8d206e05229d9b"
  end

  depends_on "go" => :build

  def install
    chdir "cmd/risor" do
      ldflags = "-s -w -X 'main.version=#{version}' -X 'main.date=#{time.iso8601}'"
      tags = "aws,k8s,vault"
      system "go", "build", *std_go_args(ldflags:, tags:)
      generate_completions_from_executable(bin/"risor", "completion")
    end
  end

  test do
    output = shell_output("#{bin}/risor -c \"time.now()\"")
    assert_match(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}/, output)
    assert_match version.to_s, shell_output("#{bin}/risor version")
    assert_match "module(aws)", shell_output("#{bin}/risor -c aws")
    assert_match "module(k8s)", shell_output("#{bin}/risor -c k8s")
    assert_match "module(vault)", shell_output("#{bin}/risor -c vault")
  end
end
