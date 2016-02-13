# coding: utf-8

require "spec_helper"

describe ConfidentialInfoManager::Core do

  shared_examples_for "encrypt and decrypt" do
    it "encrypt and decrypt" do
      confidential_info_manager = described_class.new(password)
      encrypted_data = confidential_info_manager.encrypt(raw_data)
      expect(raw_data).not_to eq(encrypted_data)
      decrypted_data = confidential_info_manager.decrypt(encrypted_data, type)
      expect(raw_data).to eq(decrypted_data)
      expect(decrypted_data).to be_instance_of(type)
    end
  end

  context "secret string data encrypt and decrypt" do
    let!(:password) { "pass" }
    let!(:raw_data) { "raw test data string" }
    let!(:type) { String }
    it_should_behave_like "encrypt and decrypt"
  end

  context "secret integer data encrypt and decrypt" do
    let!(:password) { "pass" }
    let!(:raw_data) { 10 }
    let!(:type) { Fixnum }
    it_should_behave_like "encrypt and decrypt"
  end

  context "secret float data encrypt and decrypt" do
    let!(:password) { "pass" }
    let!(:raw_data) { 0.5 }
    let!(:type) { Float }
    it_should_behave_like "encrypt and decrypt"
  end

  context "secret array data encrypt and decrypt" do
    let!(:password) { "pass" }
    let!(:raw_data) { ["ruby", "java", "python", "scala", "php"] }
    let!(:type) { Array }
    it_should_behave_like "encrypt and decrypt"
  end

  context "secret hash data encrypt and decrypt" do
    let!(:password) { "pass" }
    let!(:raw_data) { { key: "val" } }
    let!(:type) { Hash }
    it_should_behave_like "encrypt and decrypt"
  end

  it "separately to generate the encrypter instance and decrypte instance" do
    password = "pass"
    raw_data = "secret data"
    encrypter = described_class.new(password)
    encrypted_data = encrypter.encrypt(raw_data)
    expect(raw_data).not_to eq(encrypted_data)
    decrypter = described_class.new(password)
    decrypted_data = decrypter.decrypt(encrypted_data)
    expect(raw_data).to eq(decrypted_data)
  end

  context "encrypt and decrypt on command line" do
    let!(:password) { "pass" }
    let!(:raw_data) { "secret data" }

    it "encrypt on command line" do
      encrypted_data = `echo #{raw_data} | openssl enc -e -aes-256-cbc -base64 -pass pass:#{password}`
      decrypter = described_class.new(password, "AES-256-CBC", 1)
      decrypted_data = decrypter.decrypt(encrypted_data.chomp)
      expect(decrypted_data.chomp).to eq(raw_data)
    end

    it "decrypt on command line" do
      encrypter = described_class.new(password,"AES-256-CBC", 1)
      encrypted_data = encrypter.encrypt(raw_data)
      decrypted_data = `echo #{encrypted_data} | openssl enc -d -aes-256-cbc -base64 -pass pass:#{password}`
      expect(decrypted_data).to eq(raw_data)
    end
  end

end
