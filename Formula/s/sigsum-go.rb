class SigsumGo < Formula
  desc "Key transparency toolkit"
  homepage "https://sigsum.org"
  url "https://git.glasklar.is/sigsum/core/sigsum-go/-/archive/v0.10.0/sigsum-go-v0.10.0.tar.bz2"
  sha256 "b74e5e1e192d0be9860cff8153e778aeec3a703637668e8f0c5d4c426e2b4eed"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7014991ad0f6a7f496dac69aea18c4490d4a4fd88f4dd36bb5956ceaf577885"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7014991ad0f6a7f496dac69aea18c4490d4a4fd88f4dd36bb5956ceaf577885"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f7014991ad0f6a7f496dac69aea18c4490d4a4fd88f4dd36bb5956ceaf577885"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5fbfa9b8578f857989d80a8ccc9e16f41b25989f575aa2293d565efe9734563"
    sha256 cellar: :any_skip_relocation, ventura:       "e5fbfa9b8578f857989d80a8ccc9e16f41b25989f575aa2293d565efe9734563"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05b65af19ba9f4c2974aa45f38e698c75ed2dc93811f80491eabd39ea7c02d15"
  end

  depends_on "go" => :build

  def install
    %w[
      sigsum-key
      sigsum-monitor
      sigsum-submit
      sigsum-token
      sigsum-verify
      sigsum-witness
    ].each do |cmd|
      system "go", "build", *std_go_args(output: bin/cmd, ldflags: "-s -w"), "./cmd/#{cmd}"
    end
  end

  test do
    system bin/"sigsum-key", "gen", "-o", "key-file"
    pipe_output("#{bin}/sigsum-key sign -k key-file -o signature", (bin/"sigsum-key").read)
    pipe_output("#{bin}/sigsum-key verify -k key-file.pub -s signature", (bin/"sigsum-key").read)
  end
end
