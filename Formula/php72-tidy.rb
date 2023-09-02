require File.expand_path("../../Abstract/abstract-php-extension", __FILE__)

class Php72Tidy < AbstractPhp72Extension
  init
  desc "Tidy HTML clean and repair utility"
  homepage "https://php.net/manual/en/book.tidy.php"
  revision 19


  url PHP_SRC_TARBALL
  sha256 PHP_CHECKSUM[:sha256]

  bottle do
    root_url "https://f003.backblazeb2.com/file/homebrew-bottles/php72"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "03025e86554a9f1d06a0c3196b1b5d2ca0fb2c3f67768cc090f53322be61689d"
    sha256 cellar: :any_skip_relocation, ventura:       "4027f9e5f372490826d861d0e6b8e5a15e51259987bbe88f06973447fdd6d3bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73c1ab1a5441880771ca82a2e1d808522d7445128e2f1364fee24170def187c7"
  end

  depends_on "digitalspacestdio/php/php-tidy-html5"

  def install
    Dir.chdir "ext/tidy"

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          phpconfig,
                          "--disable-dependency-tracking",
                          "--with-tidy=#{Formula["digitalspacestdio/php/php-tidy-html5"].opt_prefix}"
    system "make"
    prefix.install "modules/tidy.so"
    write_config_file if build.with? "config-file"
  end
end
