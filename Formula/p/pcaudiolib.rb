class Pcaudiolib < Formula
  desc "Portable C Audio Library"
  homepage "https://github.com/espeak-ng/pcaudiolib"
  license "GPL-3.0-or-later"

  stable do
    url "https://github.com/espeak-ng/pcaudiolib/releases/download/1.2/pcaudiolib-1.2.tar.gz"
    sha256 "6fae11e87425482acbb12c4e001282d329be097074573060f893349255d3664b"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  head do
    url "https://github.com/espeak-ng/pcaudiolib.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "alsa-lib"
    depends_on "pulseaudio"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <pcaudiolib/audio.h>

      int main() {
        struct audio_object *my_audio = create_audio_device_object(NULL, "test", "test");
        int error = audio_object_open(my_audio, AUDIO_OBJECT_FORMAT_S16LE, 22050, 1);
        if (error != 0)
          printf("audio_object_open error: %s", audio_object_strerror(my_audio, error));
        audio_object_close(my_audio);
        audio_object_destroy(my_audio);
        return error;
      }
    EOS

    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lpcaudio"
    system "./test"
  end
end
