module Sinatra
  module PhotoHelper
    GALLERY_PREFIX = "http://martesmartes.org/lutreola/photo_gallery/"
    HEADER_MINKS = ["headpic1.gif", "headpic2.gif", "headpic3.gif",
                    "headpic4.gif", "headpic5.gif"].map { |f| "/images/" + f }
    
    def rand_header_mink
      HEADER_MINKS[rand(HEADER_MINKS.size)]
    end

    def photo_url(file)
      GALLERY_PREFIX + file
    end
  end
  
  helpers PhotoHelper
end
