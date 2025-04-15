class WhisperkitCli < Formula
  desc "Swift native on-device speech recognition with Whisper for Apple Silicon"
  homepage "https://github.com/argmaxinc/WhisperKit"
  url "https://github.com/argmaxinc/WhisperKit/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "4ca4da6ad191f8582477aaf361034196a14f21f1949ebfeb162ee55a4582fe6a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ab5638391dc872230d63257f097d6175587f7296db70a2e04252debf17dfe48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52901ca7d2441a670fdaa5b2b34f3b75b62d190bef7eeee398071613a9711790"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f6814621ef7379644db8fc7a954bde595992515187473eea3932ee5d6db7678a"
  end

  depends_on xcode: ["15.0", :build]
  depends_on arch: :arm64
  depends_on :macos
  depends_on macos: :ventura

  uses_from_macos "swift"

  def install
    system "swift", "build", "-c", "release", "--product", "whisperkit-cli", "--disable-sandbox"
    bin.install ".build/release/whisperkit-cli"
  end

  test do
    mkdir_p "#{testpath}/tokenizer"
    mkdir_p "#{testpath}/model"

    test_file = test_fixtures("test.mp3")
    output = shell_output("#{bin}/whisperkit-cli transcribe --model tiny --download-model-path #{testpath}/model " \
                          "--download-tokenizer-path #{testpath}/tokenizer --audio-path #{test_file} --verbose")
    assert_match "Transcription of test.mp3", output
  end
end
