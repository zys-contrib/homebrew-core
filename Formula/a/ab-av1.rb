class AbAv1 < Formula
  desc "AV1 re-encoding using ffmpeg, svt-av1 & vmaf"
  homepage "https://github.com/alexheretic/ab-av1"
  url "https://github.com/alexheretic/ab-av1/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "9f5926f9e11c1d7ad86d9c993fbf2bed00bc64e3710cba16f89dca706eceea55"
  license "MIT"
  head "https://github.com/alexheretic/ab-av1.git", branch: "main"

  depends_on "rust" => :build
  depends_on "ffmpeg"

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"ab-av1", "print-completions", shells: [:bash, :zsh])
  end

  test do
    resource "sample-mp4" do
      url "https://download.samplelib.com/mp4/sample-5s.mp4"
      sha256 "05bd857af7f70bf51b6aac1144046973bf3325c9101a554bc27dc9607dbbd8f5"
    end

    assert_match "ab-av1 #{version}", shell_output("#{bin}/ab-av1 --version")

    resource("sample-mp4").stage testpath
    system bin/"ab-av1", "auto-encode", "-i", testpath/"sample-5s.mp4"
    assert_path_exists testpath/"sample-5s.av1.mp4"
  end
end
