class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v2.4.2.tar.gz"
  sha256 "10b5acc2c48949da60831769e01836a3b0226b2b86358fad714f40b70ea09da9"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "967bf9b08bf49bc36e945ae08fb5809c63b7886513c2690fb3cf17de59b50560"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "967bf9b08bf49bc36e945ae08fb5809c63b7886513c2690fb3cf17de59b50560"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "967bf9b08bf49bc36e945ae08fb5809c63b7886513c2690fb3cf17de59b50560"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f054b592c5b4fc98f6c7721d0446deae881c58899a5f8046e24a90fde3eeff9"
    sha256 cellar: :any_skip_relocation, ventura:       "9f054b592c5b4fc98f6c7721d0446deae881c58899a5f8046e24a90fde3eeff9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65f10ad8befae78909aa69dffe5d455610fc590df4ebe4d8528ef92d654a3385"
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
