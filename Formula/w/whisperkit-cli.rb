class WhisperkitCli < Formula
  desc "Swift native on-device speech recognition with Whisper for Apple Silicon"
  homepage "https://github.com/argmaxinc/WhisperKit"
  url "https://github.com/argmaxinc/WhisperKit/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "a1f138bea9899e838c400fa1576c1eb2ee4bbfa7d59280b3a6b63237550003fa"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c7c43d484d7b2d286202c63cc6993d4b30798b0cad55297d69e48f6d03b69a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d7e9081292429e219e69b17565102de55dc344d2733bff941658ed5589b8761"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a57bdecfcb3544967fac49cde1cabe4726a8203dc26e6752b66610e256986497"
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
