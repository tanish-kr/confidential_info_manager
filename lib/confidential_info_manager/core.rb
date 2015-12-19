# coding: utf-8

module ConfidentialInfoManager

  ##
  # Condidential info manager core class
  # @author tatsunori nishikori <tora.1986.tatsu@gmail.com>
  class Core

    RANDOM_BYTES = 8.freeze
    ITERATOR_COUNT = 2000.freeze

    ##
    # constructor
    # @param [String] password
    # @param [String] mode
    # @see OpenSSL::Ciper.ciphers
    def initialize(password, mode="AES-256-CBC")
      generate_encrypter(mode)
      generate_decrypter(mode)
      set_key_and_iv(password)
    end

    ##
    # encrypt
    # @param [Object] secret data
    # @return [String] encrypted data
    def encrypt(secret_data)
      # convert string
      case secret_data
        when Numeric
          secret_data = secret_data.to_s
        when Hash, Array
          secret_data = Marshal.dump(secret_data)
      end

      @@encrypter.reset

      encrypted_data = ""
      encrypted_data << @@encrypter.update(secret_data)
      encrypted_data << @@encrypter.final
    end

    ##
    # decrypt
    # @param [String] encrypted data
    # @param [Class] type
    #   @note String/Fixnum/Bignum/Float/Array/Hash
    # @return [Object] decrypted data
    def decrypt(encrypted_data, type=String)
      @@decrypter.reset

      decrypted_data = ""
      decrypted_data << @@decrypter.update(encrypted_data)
      decrypted_data << @@decrypter.final

      if type == Fixnum || type == Bignum
        decrypted_data = decrypted_data.to_i
      elsif type == Float
        decrypted_data = decrypted_data.to_f
      elsif type == Array || type == Hash
        decrypted_data = Marshal.load(decrypted_data)
      end
      decrypted_data
    end

    ##
    # encrypt only value
    # @param [Object] secret_data
    #   @note Object is allowed an Hash or Array
    # @return [Object] encrypted data
    #   @note Array/Hash
    def encrypt_only_value(secret_data)
      case secret_data
        when Hash
          Hash[secret_data.map { |key, val| [key, encrypt(val)] }]
        when Array
          secret_data.map { |val| encrypt(val) }
        else
          encrypt(secret_data)
      end
    end

    ##
    # decrypt only value
    # @param [Object] encrypted_data
    #   @note Object is allowed an Hash or Array
    # @return [Object] decrypted data
    #   @note Array/Hash
    def decrypt_only_value(encrypted_data)
      case encrypted_data
        when Hash
          Hash[encrypted_data.map { |key, val| [key, decrypt(val)] }]
        when Array
          encrypted_data.map { |val| decrypt(val) }
        else
          decrypt(encrypted_data)
      end
    end

private

    ##
    # setting key and iv
    # @param [String] password
    def set_key_and_iv(password)
      salt = OpenSSL::Random.random_bytes(RANDOM_BYTES)
      # Generated from the password and salt the key and IV in accordance with PKCS#5
      key_iv = OpenSSL::PKCS5.pbkdf2_hmac_sha1(
        password, salt, ITERATOR_COUNT,
        @@encrypter.key_len + @@encrypter.iv_len
      )
      key = key_iv[0, @@encrypter.key_len]
      iv = key_iv[@@encrypter.key_len, @@encrypter.iv_len]
      # Set the key and IV
      @@encrypter.key = key
      @@encrypter.iv = iv
      @@decrypter.key = key
      @@decrypter.iv = iv
    end

    ##
    # generate encrypter
    # @param [String] mode
    def generate_encrypter(mode)
      @@encrypter = OpenSSL::Cipher.new(mode)
      @@encrypter.encrypt
    end

    ##
    # generate decrypter
    # @param [String] mode
    def generate_decrypter(mode)
      @@decrypter = OpenSSL::Cipher.new(mode)
      @@decrypter.decrypt
    end

  end

end
