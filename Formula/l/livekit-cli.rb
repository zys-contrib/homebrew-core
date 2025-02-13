class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  stable do
    url "https://github.com/livekit/livekit-cli/archive/refs/tags/v2.3.3.tar.gz"
    sha256 "a01ce7e297566aab77f97fabf4a4fe13755a5039bd35a5e440c9e94630125bd2"

    # version patch, upstream pr ref, https://github.com/livekit/livekit-cli/pull/521
    patch do
      url "https://github.com/livekit/livekit-cli/commit/9a8ecb16d1822d1ec5fe3d78df91ec93dd7e6f4b.patch?full_index=1"
      sha256 "ca323f16e12ab9afaa129c27ecd24d82f18d68404b4d05d6dd0cdc43255278e1"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29ede68106fb24c536be46046cbdc82e10752c5ba80a0e3fdd88427d11750a38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29ede68106fb24c536be46046cbdc82e10752c5ba80a0e3fdd88427d11750a38"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "29ede68106fb24c536be46046cbdc82e10752c5ba80a0e3fdd88427d11750a38"
    sha256 cellar: :any_skip_relocation, sonoma:        "4994f1108d240c06623186573630ca7b8991c40624a9faf95af53511410c4c59"
    sha256 cellar: :any_skip_relocation, ventura:       "4994f1108d240c06623186573630ca7b8991c40624a9faf95af53511410c4c59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d354273f468a08fb12a66c90253c55e46df39193632c65b24df0d04bd854b6fe"
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
