class Observerward < Formula
  desc "Web application and service fingerprint identification tool"
  homepage "https://emo-crab.github.io/observer_ward/"
  url "https://github.com/emo-crab/observer_ward/archive/refs/tags/v2025.3.23.tar.gz"
  sha256 "569a7a7c7d1adce237bf151981dcb5dd98009bb4dd4fc7a3e96d7b58fade56d6"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c401dec7dca5407da20c122458cbcea8a8b92862ee1310783d8503601aa1d224"
    sha256 cellar: :any,                 arm64_sonoma:  "c3989e1b4991cb1c8a99121bb89a9c8f20db13cee82b8e7db65f11d10779feca"
    sha256 cellar: :any,                 arm64_ventura: "4b738cc306be1ca64405932b5aeb4a80105db5464f9f3fb396936d6e1dcd298c"
    sha256 cellar: :any,                 sonoma:        "640f640385535222de1215ade4372817c43aea4de52d97034433950497a804e3"
    sha256 cellar: :any,                 ventura:       "08d80c52700f6c03f98aab4e1b8680aa76ce56cddb08c6cef2f9e24265fc135f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "801c0e8486d7deacb402507848cf17ba8573d2730efea0dbbf44cdea70f5cbed"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "observer_ward")
  end

  test do
    require "utils/linkage"

    system bin/"observer_ward", "-u"
    assert_match "0example", shell_output("#{bin}/observer_ward -t https://www.example.com/")
  end
end
