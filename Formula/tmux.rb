class Tmux < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"
  url "https://github.com/tmux/tmux/releases/download/3.0a/tmux-3.0a.tar.gz"
  sha256 "4ad1df28b4afa969e59c08061b45082fdc49ff512f30fc8e43217d7b0e5f8db9"
  revision 1

  bottle do
    root_url "https://artifacts.apple.com/brew-bottles-core-binaries-local/homebrew-core/tmux/54a7f95c"
    cellar :any
    rebuild 1
    sha256 "206811cb9cafece9769d56ad470c004dc35d7085aedb0f02bcb889b209117d5d" => :nmos
    sha256 "2c6e40600a6e8d417d923f89589bd658dd0c67ac42c05b0d4d83180f3b50e3fa" => :catalina
    sha256 "6825064806995c50f570f60993145217147a2aa74e2fe43894ba4d5e52ee760a" => :mojave
  end

  head do
    url "https://github.com/tmux/tmux.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "utf8proc" => :build
  depends_on "libevent"
  depends_on "ncurses"

  resource "completion" do
    url "https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/homebrew_1.0.0/completions/tmux"
    sha256 "05e79fc1ecb27637dc9d6a52c315b8f207cf010cdcee9928805525076c9020ae"
  end

  def install
    system "sh", "autogen.sh" if build.head?

    args = %W[
      --enable-utf8proc
      --disable-Dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}
    ]

    ENV.append "LDFLAGS", "-lresolv"
    system "./configure", *args

    system "make", "install"

    pkgshare.install "example_tmux.conf"
    bash_completion.install resource("completion")
  end

  def caveats; <<~EOS
    Example configuration has been installed to:
      #{opt_pkgshare}
  EOS
  end

  test do
    system "#{bin}/tmux", "-V"
  end
end
