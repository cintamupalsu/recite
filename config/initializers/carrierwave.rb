if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      # Configuration for Amazon S3
      provider:               'AWS',
      aws_access_key_id:      ENV['AKIAIRPV6XTR5GBI2JOQ'],
      aws_secret_access_key:  ENV['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']
    }
    config.fog_directory = ENV['openhadith']
  end
end