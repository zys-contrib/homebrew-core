class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https://github.com/alexpasmantier/television"
  url "https://github.com/alexpasmantier/television/archive/refs/tags/0.10.3.tar.gz"
  sha256 "b1df3632463982f203ac8682534f1e34729c7d635aab7dc45bca4877b56f2585"
  license "MIT"
  head "https://github.com/alexpasmantier/television.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b8b77981102c7d77ea4a948248f04afeabf031d68dad7137ab34926a3c099cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4924ff379840dc05c184dc23779c8c76d17620698d55b1d32500838fcb6e200"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2878207e2ced5a8dced06ef30b11bc0cfe6b50a6621408b1cd48bf179c548895"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac3385960b20865c867d1b147221ae870568a139b342e9136fbccaeeac35f6bc"
    sha256 cellar: :any_skip_relocation, ventura:       "e8bb2edb1dbaaeb09be3589181a0a4f9a1caf07a538016ae7f8edc912dadd842"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d27a18e02a73a51b4e5d0e1d943ba2fa3794f2f4387e48ba6d6a5a1f0809364"
  end

  depends_on "rust" => :build

  conflicts_with "tidy-viewer", because: "both install `tv` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tv -V")

    output = shell_output("#{bin}/tv list-channels")
    assert_match "Builtin channels", output
  end
end
