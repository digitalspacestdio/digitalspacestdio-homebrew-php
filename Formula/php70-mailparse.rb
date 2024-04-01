require File.expand_path("../../Abstract/abstract-php-extension", __FILE__)

class Php70Mailparse < AbstractPhp70Extension
  init
  desc "Extension for parsing email messages."
  homepage "https://pecl.php.net/package/mailparse"
  url "https://pecl.php.net/get/mailparse-3.0.2.tgz"
  sha256 "d81a6f8a48e43fca1c0f0d6c90d666830c24d584a23a60add43062aaf221843b"
  head "https://github.com/php/pecl-mail-mailparse.git"
  revision PHP_REVISION

  depends_on "pcre2"

  def install
    Dir.chdir "mailparse-#{version}" unless build.head?

    ENV.append "LDFLAGS", "-L#{Formula["pcre2"].opt_prefix}/lib"
    ENV.append "CPPFLAGS", "-I#{Formula["pcre2"].opt_prefix}/include"

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          phpconfig
    system "make"
    prefix.install "modules/mailparse.so"
    write_config_file if build.with? "config-file"
  end
end
