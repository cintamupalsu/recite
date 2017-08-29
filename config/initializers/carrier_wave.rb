if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      # Configuration for Amazon S3
      :provider => 'AWS',
      :aws_access_key_id => ENV['AKIAIBAP4BKZJ5WDI5ZQ'],
      :aws_secret_access_key => ENV['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']
    }
    config.fog_directory = ENV['openhadith']
  end
end