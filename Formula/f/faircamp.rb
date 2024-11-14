class Faircamp < Formula
  desc "Static site generator for audio producers"
  homepage "https://codeberg.org/simonrepp/faircamp"
  url "https://codeberg.org/simonrepp/faircamp/archive/0.20.1.tar.gz"
  sha256 "5bb4f310a9377e67c4f938209581ae323f70b1527791c365184d1b6899925040"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "dbed5e82cf79b7124666674a5c7c658f9c74d94a5178e78917f0668d33d387d6"
    sha256 cellar: :any, arm64_sonoma:  "a7a9216b72f0a4e8c9756f69dff5648143d4a0afbacfa9ccafc03bfbbf163a6b"
    sha256 cellar: :any, arm64_ventura: "766d35829411c06fdc3dc3369d210a631e2df932db66de436843a631f94b71c4"
    sha256 cellar: :any, sonoma:        "b83e5b5428a374e6d1561f6bbfae272b116ab82941601bef5516c8f14501ed21"
    sha256 cellar: :any, ventura:       "9d481e4806622d87f9368f5ad29c6b2a93ebf9eb5909adf9e4df03caccbbc800"
  end

  depends_on "opus" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg"
  depends_on "gettext"
  depends_on "glib"
  # Brew's libopus behaves differently in linux compared to macOS and
  # results in runtime errors. Further investigation and work on this
  # formulae is needed to support linux builds. The upstream project
  # provides their own mechanism for linux distribution. Brew is most
  # valuable on macOS, where there is no other suitable package manager,
  # so for now, restrict this formulae to macOS.
  depends_on :macos
  depends_on "vips"

  def install
    # libvips is a runtime dependency, the brew install location is
    # not discovered by default by Cargo. Upstream issue:
    #   https://codeberg.org/simonrepp/faircamp/issues/45
    ENV["RUSTFLAGS"] = `pkg-config --libs vips`.chomp
    system "cargo", "install", *std_cargo_args, "--features", "libvips"
  end

  test do
    # Check properly compiled with optional libvips feature
    version_str = shell_output("#{bin}/faircamp --version").chomp
    assert_match "faircamp #{version} (compiled with libvips)", version_str

    # Check site generation
    catalog_dir = testpath/"Catalog"
    album_dir = catalog_dir/"Artist"/"Album"
    mkdir_p album_dir
    cp test_fixtures("test.wav"), album_dir/"Track01.wav"
    cp test_fixtures("test.wav"), album_dir/"Track02.wav"
    cp test_fixtures("test.jpg"), album_dir/"artwork.jpg"

    output_dir = testpath/"html"
    system bin/"faircamp", "--catalog-dir", catalog_dir, "--build-dir", output_dir

    assert_path_exists output_dir/"favicon.svg"
    assert_path_exists output_dir/"album"/"index.html"
    assert_path_exists output_dir/"album"/"cover_1.jpg"
    assert_path_exists output_dir/"album"/"opus-96"/"ASINtk0hKII"/"01 Track01.opus"
    assert_path_exists output_dir/"album"/"opus-96"/"uWPoxZFX0kQ"/"02 Track02.opus"
    assert_path_exists output_dir/"album"/"mp3-v5"/"1syLQAjRlm8"/"01 Track01.mp3"
    assert_path_exists output_dir/"album"/"mp3-v5"/"zh4GTzy3VT0"/"02 Track02.mp3"
  end
end
