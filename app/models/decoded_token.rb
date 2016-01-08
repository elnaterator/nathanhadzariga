class DecodedToken < HashWithIndifferentAccess

  def expired?
    Time.now.to_i > self[:exp]
  end

end
