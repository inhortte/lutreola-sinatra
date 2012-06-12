require 'sinatra/base'

module Sinatra
  module AuthenticationHelper
    def authenticate(username, password)
      m = Member.first(:username => username) ||
        Member.first(:email => username)
      return nil if m.nil?
      return m if m.has_password?(password)
    end
  end

  module MemberHelper
    def get_member
      if session[:id]
        return Member.get(session[:id])
      end
    end

    def clear_member
      session[:id] = nil
    end

    def admin?
      get_member && get_member.class == Admin
    end

    def admin_page?
      request.path_info =~ %r{^/admin}
    end
  end

  helpers AuthenticationHelper
  helpers MemberHelper
end
