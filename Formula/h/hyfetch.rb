class Hyfetch < Formula
  include Language::Python::Virtualenv

  desc "Fast, highly customisable system info script with LGBTQ+ pride flags"
  homepage "https://github.com/hykilpikonna/hyfetch"
  url "https://files.pythonhosted.org/packages/1f/7d/7acc8fd22a1a4861f6a3833fbba8d1ffc6d118d143a4cbaab7f998867b4e/HyFetch-1.99.0.tar.gz"
  sha256 "ddeb422fd797c710f0ad37d584fac466df89e39feddeef765492b2c0b529616e"
  license "MIT"
  head "https://github.com/hykilpikonna/hyfetch.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b754e3cd3c2e292dcf7bcf6e9f429241f8d10e1cde3e606d97ab1ccedcbe1d8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b754e3cd3c2e292dcf7bcf6e9f429241f8d10e1cde3e606d97ab1ccedcbe1d8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b754e3cd3c2e292dcf7bcf6e9f429241f8d10e1cde3e606d97ab1ccedcbe1d8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "74af52c7460c51175930a3b44b67817b284a259583b1cfe810437d8f16ab5f06"
    sha256 cellar: :any_skip_relocation, ventura:       "74af52c7460c51175930a3b44b67817b284a259583b1cfe810437d8f16ab5f06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ece3b8c1f3d62805822839f483448ca8c70c401419a8644595df47f3e9a32404"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/".config/hyfetch.json").write <<-EOS
    {
      "preset": "genderfluid",
      "mode": "rgb",
      "light_dark": "dark",
      "lightness": 0.5,
      "color_align": {
        "mode": "horizontal",
        "custom_colors": [],
        "fore_back": null
      },
      "backend": "neofetch",
      "distro": null,
      "pride_month_shown": [],
      "pride_month_disable": false
    }
    EOS

    system bin/"neowofetch", "--config", "none", "--color_blocks", "off",
                              "--disable", "wm", "de", "term", "gpu"
    system bin/"hyfetch", "-C", testpath/"hyfetch.json",
                             "--args=\"--config none --color_blocks off --disable wm de term gpu\""
  end
end
