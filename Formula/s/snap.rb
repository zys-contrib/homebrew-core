class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https://snapcraft.io/"
  url "https://github.com/snapcore/snapd/releases/download/2.68.4/snapd_2.68.4.vendor.tar.xz"
  version "2.68.4"
  sha256 "8c6ad7ee2c2a4cb5b59f836a74843cf8337e692dddd33b85c17418e7a6837e80"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62cc3b0aad9030c162d73c17a9da014e90b367e9f139981fa04cd73ea57a3482"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62cc3b0aad9030c162d73c17a9da014e90b367e9f139981fa04cd73ea57a3482"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "62cc3b0aad9030c162d73c17a9da014e90b367e9f139981fa04cd73ea57a3482"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9b28c4ac7d2176e82e7fa08e74e01e2650e9a16dbabb9376e54759889a57c01"
    sha256 cellar: :any_skip_relocation, ventura:       "a9b28c4ac7d2176e82e7fa08e74e01e2650e9a16dbabb9376e54759889a57c01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efe9ca2c31c5a38ade0e872cc918c532e33e6fe572d4f2ec6ba0ee93aa1bb843"
  end

  depends_on "go" => :build
  depends_on "squashfs"

  def install
    system "./mkversion.sh", version.to_s
    tags = OS.mac? ? ["-tags=nosecboot"] : []
    system "go", "build", *std_go_args(ldflags: "-s -w"), *tags, "./cmd/snap"

    bash_completion.install "data/completion/bash/snap"
    zsh_completion.install "data/completion/zsh/_snap"

    (man8/"snap.8").write Utils.safe_popen_read(bin/"snap", "help", "--man")
  end

  test do
    (testpath/"pkg/meta").mkpath
    (testpath/"pkg/meta/snap.yaml").write <<~YAML
      name: test-snap
      version: 1.0.0
      summary: simple summary
      description: short description
    YAML
    system bin/"snap", "pack", "pkg"
    system bin/"snap", "version"
  end
end
