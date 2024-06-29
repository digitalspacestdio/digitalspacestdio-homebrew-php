require File.expand_path("../../Abstract/abstract-php-extension", __FILE__)

class Php70Tidy < AbstractPhp70Extension
  init
  desc "Tidy HTML clean and repair utility"
  homepage "https://php.net/manual/en/book.tidy.php"
  revision PHP_REVISION

  url PHP_SRC_TARBALL
  sha256 PHP_CHECKSUM[:sha256]

  bottle do
    root_url "https://l2i5.c19.e2-3.dev/homebrew/php/7.0.33-103"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f42d26df3b2a9057ae432cabf3ef9333e63add5fb6ec95896711823fea599ce"
    sha256 cellar: :any_skip_relocation, monterey:       "81df384c79f5c7c648cd5d193ac88ca4e44ae442f664595192b270ab110b3f80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0860dab4ece0b827c8931fd6875fd906e2dff4821737ddf889e26c480b96304"
  end

  depends_on "tidy-html5"

  def install
    Dir.chdir "ext/tidy"

    # API compatibility with tidy-html5 v5.0.0 - https://github.com/htacg/tidy-html5/issues/224
    inreplace "tidy.c", "buffio.h", "tidybuffio.h"

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          phpconfig,
                          "--disable-dependency-tracking",
                          "--with-tidy=#{Formula["tidy-html5"].opt_prefix}"
    system "make"
    prefix.install "modules/tidy.so"
    write_config_file if build.with? "config-file"
  end
end
