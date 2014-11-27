CarrierWave.configure do |config|
 if Rails.env.test? || Rails.env.development?
    config.storage = :file
  else
    config.storage = :fog
    config.fog_credentials = {
      provider: "AWS",
      aws_access_key_id: Rails.application.secrets.aws_access_key_id,
      aws_secret_access_key: Rails.application.secrets.aws_secret_access_key,
      region: Rails.application.secrets.aws_region
    }
    config.fog_directory = Rails.application.secrets.aws_bucket
  end
end