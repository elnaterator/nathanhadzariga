class AuthenticationService

  def self.tokenize(claims)
    exp = Figaro.env.session_timeout_seconds.to_i.seconds.from_now
    claims.merge!({ exp: exp.to_i })
    JWT.encode claims, Rails.application.secrets.secret_key_base, 'HS256'
  end

  def self.decode(token)
    begin
      claims = JWT.decode token, Rails.application.secrets.secret_key_base, { alg: 'HS256' }
      DecodedToken.new(claims[0])
    rescue JWT::DecodeError
      nil
    end
  end

end
