require 'json'

class Session
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    @req = req
  end

  def [](key)
    @req.cookies[key]
  end

  def []=(key, val)
    @req.cookies[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    # @cookie = res.set_cookie('_rails_lite_app', {:path => '/', :value => @req.to_json})

    if self['_rails_lite_app'].nil?
      res.set_cookie('_rails_lite_app', {:path => '/', :value => @req.to_json})
    else
      new_cookie = self['_rails_lite_app']
      res.set_cookie('_rails_lite_app', new_cookie)
    end
  end
end
