require File.expand_path("../../Abstract/abstract-php-extension", __FILE__)

class Php73Ldap < AbstractPhp73Extension
  init
  desc "LDAP Support"
  homepage "https://php.net/manual/en/book.ldap.php"
  revision PHP_REVISION


  url PHP_SRC_TARBALL
  sha256 PHP_CHECKSUM[:sha256]

  bottle do
    root_url "https://f003.backblazeb2.com/file/homebrew-bottles/php73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e600bf4710bd35966a1ff420992ca76ee41276be29fdd725df3572171c30d5a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d2fea195990689ab4c8b6d4e28ca172bed2250454d7fcae537fb5894efe7166f"
    sha256 cellar: :any_skip_relocation, sonoma:        "69ef88030c69836ff5e809a73caf56c7a8c08605205dccc5db21f05332210739"
    sha256 cellar: :any_skip_relocation, monterey:      "bdc120d63efa4c2acbaa8d9009fbbe47adb338f7644b3e46052163a6dd6f169b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08ca454545275ebb0094a92267a3b82a1d385d5f38df0414dae15f4f7d7db212"
  end

  depends_on "openldap"

  def install
    Dir.chdir "ext/ldap"
    safe_phpize

    if OS.mac?
      ENV["SASL_CFLAGS"] = "-I#{MacOS.sdk_path_if_needed}/usr/include/sasl"
      ENV["SASL_LIBS"] = "-lsasl2"
      headers_path = "=#{MacOS.sdk_path_if_needed}/usr"
      system "./configure", "--prefix=#{prefix}",
                            phpconfig,
                            "--disable-dependency-tracking",
                            "--with-ldap=#{Formula["openldap"].opt_prefix}",
                            "--with-ldap-sasl#{headers_path}"
    else
      system "./configure", "--prefix=#{prefix}",
                          phpconfig,
                          "--disable-dependency-tracking",
                          "--with-ldap=#{Formula["openldap"].opt_prefix}"
    end
    system "make"
    prefix.install "modules/ldap.so"
    write_config_file if build.with? "config-file"
  end
end
