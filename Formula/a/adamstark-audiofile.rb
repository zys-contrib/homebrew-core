class AdamstarkAudiofile < Formula
  desc "C++ Audio File Library by Adam Stark"
  homepage "https://github.com/adamstark/AudioFile"
  url "https://github.com/adamstark/AudioFile/archive/refs/tags/1.1.2.tar.gz"
  sha256 "d090282207421e27be57c3df1199a9893e0321ea7c971585361a3fc862bb8c16"
  license "MIT"
  head "https://github.com/adamstark/AudioFile.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "79027b21202b73bbb3ad74b98c7c5a33f93e14ee089354174cdf7aefa9a3ec79"
  end

  def install
    include.install "AudioFile.h"
  end

  test do
    (testpath/"audiofile.cc").write <<~CPP
      #include "AudioFile.h"
      int main(int argc, char* *argv) {
        AudioFile<double> audioFile;
        AudioFile<double>::AudioBuffer abuf;
        return 0;
      }
    CPP

    system ENV.cxx, "-std=c++17",
           "-I#{include}",
           "-o", "audiofile",
           "audiofile.cc"
    system "./audiofile"
  end
end
