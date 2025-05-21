class Libplacebo < Formula
  include Language::Python::Virtualenv

  desc "Reusable library for GPU-accelerated image/video processing primitives"
  homepage "https://code.videolan.org/videolan/libplacebo"
  license "LGPL-2.1-or-later"
  head "https://code.videolan.org/videolan/libplacebo.git", branch: "master"

  stable do
    url "https://code.videolan.org/videolan/libplacebo/-/archive/v7.351.0/libplacebo-v7.351.0.tar.bz2"
    sha256 "d68159280842a7f0482dcea44a440f4c9a8e9403b82eccf185e46394dfc77e6a"

    resource "fast_float" do
      url "https://github.com/fastfloat/fast_float/archive/refs/tags/v8.0.1.tar.gz"
      sha256 "18f868f0117b359351f2886be669ce9cda9ea281e6bf0bcc020226c981cc3280"
    end

    resource "glad2" do
      url "https://files.pythonhosted.org/packages/6e/5a/d62b24fe1c7c2f34e15c2aa4418a5327a8550fdc272999a59e0dddebc3ee/glad2-2.0.8.tar.gz"
      sha256 "b84079b9fa404f37171b961bdd1d8da21370e6c818defb8481c5b3fe3d6436da"
    end

    resource "jinja2" do
      url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
      sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
    end

    resource "markupsafe" do
      url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
      sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
    end
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "3d549716eb833fbc554605706f4e4740f0c1c4e6cf23732326444627ea14a8d5"
    sha256 cellar: :any, arm64_sonoma:   "72afc163cc9dfc5525ed856094449685f034dfbbd8528f04e448b0447dd44f06"
    sha256 cellar: :any, arm64_ventura:  "8860b6fd41fdd672a503b4951cb539d8ae11eaf953b64aef8188090f862138ab"
    sha256 cellar: :any, arm64_monterey: "bfba0779b291723de7012b77cfc04e2d2909764012580e002808658697768ef2"
    sha256 cellar: :any, sonoma:         "a5f15e9286de87a34619dbd377fd26a83fddb667ff45036fa7aa09ad3ca2a3d3"
    sha256 cellar: :any, ventura:        "7ee7837caa82be9fa7294eb11f9a34545aad429a2202aaef5b19ba50dc02ea08"
    sha256 cellar: :any, monterey:       "be243d1baa8e092186e1f6a7d8be0964e243bcb77fe2372dbc3736c3a3f8d910"
    sha256               arm64_linux:    "2cae1d9fd160729c2a5885e83d65b63c4326a984eb456b2b7f63fc6f86e1cb8b"
    sha256               x86_64_linux:   "db810576ae7bfb3bc20cf244271d00ab7e24701fe77d2540cf10407b22d6392d"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
  depends_on "vulkan-headers" => :build

  depends_on "little-cms2"
  depends_on "shaderc"
  depends_on "vulkan-loader"

  def install
    resources.each do |r|
      # Override resource name to use expected directory name
      dir_name = case r.name
      when "glad2", "jinja2"
        r.name.sub(/\d+$/, "")
      else
        r.name
      end

      r.stage(Pathname("3rdparty")/dir_name)
    end

    system "meson", "setup", "build",
                    "-Dvulkan-registry=#{Formula["vulkan-headers"].share}/vulkan/registry/vk.xml",
                    "-Dshaderc=enabled", "-Dvulkan=enabled", "-Dlcms=enabled",
                    *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libplacebo/config.h>
      #include <stdlib.h>
      int main() {
        return (pl_version() != NULL) ? 0 : 1;
      }
    C
    system ENV.cc, "-o", "test", "test.c", "-I#{include}",
                   "-L#{lib}", "-lplacebo"
    system "./test"
  end
end
