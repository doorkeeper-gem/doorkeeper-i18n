# encoding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'Locale loading' do
  let(:app) do
    DoorkeeperI18n::Spec::FakeApp
  end

  let(:translate_stuff) do
    lambda do
      <<-EOS.gsub(/^  */, '')
        In French: #{I18n.t('doorkeeper.layouts.admin.nav.oauth2_provider', locale: :fr)}
        In Italian: #{I18n.t('doorkeeper.layouts.admin.nav.oauth2_provider', locale: :it)}
        In Japanese: #{I18n.t('doorkeeper.layouts.admin.nav.oauth2_provider', locale: :ja)}
      EOS
    end
  end

  context 'when i18n.available_locales are specified in config' do
    let(:translations) do
      app.run(translate_stuff) do |config|
        config.i18n.available_locales = [:fr, :it]
      end
    end

    it 'loads only specified locales' do
      expected_translations = <<-EOS.gsub(/^  */, '')
        In French: Fournisseur OAuth2
        In Italian: OAuth2 Provider
        In Japanese: translation missing: ja.doorkeeper.layouts.admin.nav.oauth2_provider
      EOS

      expect(translations).to eq(expected_translations)
    end
  end

  context 'when single locale is assigned to i18n.available_locales' do
    let(:translations) do
      app.run(translate_stuff) do |config|
        config.i18n.available_locales = 'fr'
      end
    end

    it 'loads only this locale' do
      expected_translations = <<-EOS.gsub(/^  */, '')
        In French: Fournisseur OAuth2
        In Italian: translation missing: it.doorkeeper.layouts.admin.nav.oauth2_provider
        In Japanese: translation missing: ja.doorkeeper.layouts.admin.nav.oauth2_provider
      EOS

      expect(translations).to eq(expected_translations)
    end
  end

  context 'when i18n.available_locales is not set' do
    let(:translations) { app.run(translate_stuff) }

    it 'loads all locales' do
      expected_translations = <<-EOS.gsub(/^  */, '')
        In French: Fournisseur OAuth2
        In Italian: OAuth2 Provider
        In Japanese: OAuth2 プロバイダー
      EOS

      expect(translations).to eq(expected_translations)
    end
  end
end
