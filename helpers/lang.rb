module Sinatra
  module LangHelper

    LANGS = ["en", "ee"]

    def get_lang
      session[:lang]
    end

    def get_lang_keyword
      get_lang().to_sym
    end

    def set_lang(lang)
      if LANGS.include? lang
        logger.info("The language was " + if session[:lang]
                                            session[:lang]
                                          else
                                            "not set"
                                          end)
        session[:lang] = lang
        logger.info("The language is now " + lang)
      end
    end
  end
  
  helpers LangHelper
end
