class VimtutorSequel < Formula
  desc "Advanced vimtutor for intermediate vim users"
  homepage "https://github.com/micahkepe/vimtutor-sequel"
  url "https://github.com/micahkepe/vimtutor-sequel/releases/download/v1.3.1/vimtutor-sequel-1.3.1.tar.gz"
  sha256 "190627358111d73170d4b1bc7a9823c511b44a71068a8c54207fdd116f4c2152"
  license "MIT"

  depends_on "vim"

  def install
    bin.install "vimtutor-sequel.sh" => "vimtutor-sequel"
    pkgshare.install "vimtutor-sequel.txt"
    pkgshare.install "vimtutor-sequel.vimrc"
  end

  test do
    assert_match "Vimtutor Sequel version #{version}", shell_output("#{bin}/vimtutor-sequel --version")
  end
end
