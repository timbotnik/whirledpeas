Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '266077590075606', '716a48b8edf50097794a13c770b000c7', {:scope => "user_about_me, user_birthday, user_photos, email, read_friendlists, publish_stream, offline_access"}
end