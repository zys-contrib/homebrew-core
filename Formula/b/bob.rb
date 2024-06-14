class Bob < Formula
  desc "Version manager for neovim"
  homepage "https://github.com/MordechaiHadad/bob"
  url "https://github.com/MordechaiHadad/bob/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "ddc3b97ab60e9605fa5b6d5ee80113ceb863d30ad544a551523fccdf4e9c8ff1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "03400865f9d789156b080842631f7ce2f7c0621b79a49cd81aaffc923b0169db"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d77604583ba78a46b1d3c2fbd4d8e2bff2d8f5e01ed5bd2679b17d883ba0fff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf465e6fbcb4bee5a99a747d1fb165afedf4d6484ccd53324831411827fe9eba"
    sha256 cellar: :any_skip_relocation, sonoma:         "06046b9faecefae54e300079c688bc60b28266153c05ee60381d9123d4837c52"
    sha256 cellar: :any_skip_relocation, ventura:        "cd3cae537c93dc8b3219abfe2390c79772ec68b726f539bf7ebbdeafc3508d3d"
    sha256 cellar: :any_skip_relocation, monterey:       "d66953c7750cbab02f731d2fe8931f92fe9fb14b8d77fecb5eedc34e5cd0b707"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2063d048a97550ae6fbae817ad2be70abb95ed1dd45c5e65916c861b4c8927a7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"bob", "complete")
  end

  test do
    config_file = testpath/"config.json"
    config_file.write <<~EOS
      {
        "downloads_location": "#{testpath}/.local/share/bob",
        "installation_location": "#{testpath}/.local/share/bob/nvim-bin"
      }
    EOS
    ENV["BOB_CONFIG"] = config_file
    mkdir_p "#{testpath}/.local/share/bob"
    mkdir_p "#{testpath}/.local/share/nvim-bin"

    system "#{bin}/bob", "install", "v0.9.0"
    assert_match "v0.9.0", shell_output("#{bin}/bob list")
    assert_predicate testpath/".local/share/bob/v0.9.0", :exist?
    system "#{bin}/bob", "erase"
  end
end
