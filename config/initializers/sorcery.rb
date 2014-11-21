Rails.application.config.sorcery.submodules = [:external]

Rails.application.config.sorcery.configure do |config|

  config.external_providers = [:twitter, :github]

  config.twitter.key = "#{Rails.application.secrets.sorcery_twitter_key}"
  config.twitter.secret = "#{Rails.application.secrets.sorcery_twitter_secret}"
  config.twitter.callback_url = "#{Rails.application.secrets.sorcery_twitter_callback_url}"
  config.twitter.user_info_mapping = {:email => "screen_name"}
  #
  # config.facebook.key = "81e7eb5c9bbbbaf6878a"
  # config.facebook.secret = ""
  # config.facebook.callback_url = "http://0.0.0.0:3000/oauth/callback?provider=facebook"
  # config.facebook.user_info_mapping = {:email => "name"}
  # config.facebook.access_permissions = ["email", "publish_stream"]
  #
  config.github.key = "#{Rails.application.secrets.sorcery_github_key}"
  config.github.secret = "#{Rails.application.secrets.sorcery_github_secret}"
  config.github.callback_url = "#{Rails.application.secrets.sorcery_github_callback_url}"
  config.github.user_info_mapping = {:email => "name"}
  #
  # config.google.key = ""
  # config.google.secret = ""
  # config.google.callback_url = "http://0.0.0.0:3000/oauth/callback?provider=google"
  # config.google.user_info_mapping = {:email => "email", :username => "name"}
  #
  # config.vk.key = ""
  # config.vk.secret = ""
  # config.vk.callback_url = "http://0.0.0.0:3000/oauth/callback?provider=vk"
  # config.vk.user_info_mapping = {:login => "domain", :name => "full_name"}

  config.user_config do |user|
    user.username_attribute_names = [:email]
    user.authentications_class = Authentication
  end
  config.user_class = "User"
end
