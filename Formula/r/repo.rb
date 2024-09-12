class Repo < Formula
  include Language::Python::Shebang

  desc "Repository tool for Android development"
  homepage "https://source.android.com/source/developing.html"
  url "https://gerrit.googlesource.com/git-repo.git",
      tag:      "v2.47",
      revision: "1e19f7dd61923b8835d9c6e1a7e560575dafaf1e"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "a2a57c781133cac0a369f20ef1c97497a55037e69f1fc645947cd87d96e927d3"
  end

  uses_from_macos "python"

  def install
    bin.install "repo"
    doc.install (buildpath/"docs").children

    # Need Catalina+ for `python3`.
    return if OS.mac? && MacOS.version < :catalina

    rewrite_shebang detected_python_shebang(use_python_from_path: true), bin/"repo"
  end

  test do
    assert_match "usage:", shell_output("#{bin}/repo help 2>&1")
  end
end
