require File.expand_path("../../Abstract/abstract-php-extension", __FILE__)

class Php73Sodium < AbstractPhp73Extension
  init
  desc "Sodium core php extension"
  homepage "https://php.net/manual/en/book.sodium.php"
  revision PHP_REVISION

  url PHP_SRC_TARBALL
  sha256 PHP_CHECKSUM[:sha256]

  bottle do
    root_url "https://f003.backblazeb2.com/file/homebrew-bottles/php73"
    sha256 cellar: :any_skip_relocation, sonoma:       "efef8c9a44182f9d468e26297285ab6885d4b0826dcafd5c1012ec42f0e28bba"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "586e668c6c94471525fc5e07527268bdf2a457cdded9f02b5f3d63cd94cb670b"
  end

  depends_on "libsodium"

  def install
    Dir.chdir "ext/sodium"
    ENV.append "LDFLAGS", "-L#{Formula["libsodium"].opt_prefix}/lib"
    ENV.append "CPPFLAGS", "-I#{Formula["libsodium"].opt_prefix}/include"

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          "--with-sodium=#{Formula['libsodium'].opt_prefix}",
                          phpconfig,
                          "--disable-dependency-tracking"
    system "make"
    prefix.install "modules/sodium.so"
    write_config_file if build.with? "config-file"
  end
end
