class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v2.4.8.tar.gz"
  sha256 "524d2dec529272e05832d0a842973ed7a3e3b4ee1d80bb9d9f1a3e3614979551"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7151806bfd86d58dc49ebf079e3da137ae15e827c3254996187927ea5096aa6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7151806bfd86d58dc49ebf079e3da137ae15e827c3254996187927ea5096aa6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7151806bfd86d58dc49ebf079e3da137ae15e827c3254996187927ea5096aa6c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2f49164076745bc6ea192975f98cabe3298312af5bd22acbb0f015b3a05ad91"
    sha256 cellar: :any_skip_relocation, ventura:       "d2f49164076745bc6ea192975f98cabe3298312af5bd22acbb0f015b3a05ad91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8580d4423a8586bdfec8193aa3d65896ac516d867fb6101e348200ae208f407"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:, output: bin/"lk"), "./cmd/lk"

    bin.install_symlink "lk" => "livekit-cli"

    bash_completion.install "autocomplete/bash_autocomplete" => "lk"
    fish_completion.install "autocomplete/fish_autocomplete" => "lk.fish"
    zsh_completion.install "autocomplete/zsh_autocomplete" => "_lk"
  end

  test do
    output = shell_output("#{bin}/lk token create --list --api-key key --api-secret secret")
    assert output.start_with?("valid for (mins):  5")
    assert_match "lk version #{version}", shell_output("#{bin}/lk --version")
  end
end
